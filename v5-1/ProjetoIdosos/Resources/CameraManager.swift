import AVFoundation
import CoreImage
import UIKit
import Photos
import Combine // Import Combine for ObservableObject

class CameraManager: NSObject, ObservableObject { // Conform to ObservableObject

    private let captureSession = AVCaptureSession()
    private var deviceInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video)

    private var sessionQueue = DispatchQueue(label: "video.preview.session")

    private var addToPreviewStream: ((CGImage) -> Void)?
    private let context = CIContext()
    @Published public private(set) var latestFrame: CGImage? // Use @Published for observable properties

    lazy var previewStream: AsyncStream<CGImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { cgImage in
                continuation.yield(cgImage)
            }
        }
    }()

    private var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            var isAuthorized = status == .authorized
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            return isAuthorized
        }
    }

    override init() {
        super.init()
        Task {
            await configureSession()
            await startSession()
        }
    }

    private func configureSession() async {
        guard await isAuthorized,
              let systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
        else { return }

        captureSession.beginConfiguration()
        defer {
            self.captureSession.commitConfiguration()
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)

        guard captureSession.canAddInput(deviceInput) else { return }
        guard captureSession.canAddOutput(videoOutput) else { return }

        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoRotationAngle = 90
    }

    private func startSession() async {
        guard await isAuthorized else { return }
        captureSession.startRunning()
    }

    public func saveLatestFrameToPhotos(completion: @escaping (Bool, Error?) -> Void) {
        guard let latestFrame = latestFrame else {
            completion(false, NSError(domain: "CameraManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "No frame captured yet."]))
            return
        }

        let uiImage = UIImage(cgImage: latestFrame)

        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
                }) { success, error in
                    DispatchQueue.main.async {
                        completion(success, error)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, NSError(domain: "CameraManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Photos library access not authorized."]))
                }
            }
        }
    }

    public func getLatestFrameAsUIImage() -> UIImage? {
        return latestFrame.map(UIImage.init(cgImage:))
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get pixel buffer from sample buffer.")
            return
        }

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            DispatchQueue.main.async {
                self.latestFrame = cgImage // Update the published property
                self.addToPreviewStream?(cgImage)
            }
        }
    }
}
