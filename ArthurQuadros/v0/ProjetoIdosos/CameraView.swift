import SwiftUI
import Photos
import Vision
import AVFoundation


struct CameraView: View {
    @Binding var image: CGImage?
    @StateObject var cameraManager = CameraManager()
    @State private var showPermissionAlert = false
    @State private var permissionAlertMessage = ""
    @State private var isSaving = false // To disable button during saving
    @State private var recognizedText: String = ""
    @State private var showingOCRResult: Bool = false
    @State private var showingRecognizedText: Bool = false
    let synthesizer = AVSpeechSynthesizer() // Create an AVSpeechSynthesizer instance


    var body: some View {
        ZStack {
            GeometryReader { geometry in
                if let image = image {
                    Image(decorative: image, scale: 1)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width,
                               height: geometry.size.height)
                } else {
                    ContentUnavailableView("Camera feed interrupted", systemImage: "xmark.circle.fill")
                        .frame(width: geometry.size.width,
                               height: geometry.size.height)
                }
            }

            VStack {
                Spacer()
                Button {
                    // Check photo library authorization before saving
                    PHPhotoLibrary.requestAuthorization { status in
                        DispatchQueue.main.async {
                            switch status {
                            case .authorized:
                                if let savedImage = cameraManager.latestFrame {
                                    performOCR(on: savedImage)
                                    showingOCRResult = true
                                    showingRecognizedText = true
                                } else {
                                    print("No image to perform OCR on.")
                                }
                            case .denied, .restricted:
                                permissionAlertMessage = "Please grant permission to access your Photos library in Settings to save photos."
                                showPermissionAlert = true
                            case .limited:
                                // Handle limited access if needed
                                if let savedImage = cameraManager.latestFrame {
                                    performOCR(on: savedImage)
                                    showingOCRResult = true
                                    showingRecognizedText = true
                                    
                                } else {
                                    print("No image to perform OCR on.")
                                }
                            default:
                                break
                            }
                        }
                    }
                } label: {
                    if isSaving {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "text.magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                .disabled(isSaving || cameraManager.latestFrame == nil) // Disable if saving or no image
                .padding(.bottom)

                if !recognizedText.isEmpty {
                    Text("Texto Reconhecido:")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)
                    ScrollView {
                        Button("Apagar Texto") {
                            recognizedText = ""
                            showingRecognizedText = false
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                        
                        Text(recognizedText)
                            .frame(width: 300, height: 400)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                    }
                    .frame(height: 400)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                    Button("Ouvir Texto") {
                        speakText(recognizedText)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
                }
            }
            .padding(.bottom, 80)
            .alert(isPresented: $showPermissionAlert) {
                Alert(
                    title: Text("Photo Library Access Denied"),
                    message: Text(permissionAlertMessage),
                    primaryButton: .default(Text("Settings"), action: {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                Task {
                    for await frame in cameraManager.previewStream {
                        image = frame
                    }
                }
            }
        }
    }

    private func performOCR(on cgImage: CGImage) {
        recognizedText = "" // Clear previous text

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("Error during OCR: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            DispatchQueue.main.async {
                for observation in observations {
                    guard let topCandidate = observation.topCandidates(1).first else { continue }
                    recognizedText += topCandidate.string + "\n"
                }
            }
        }

        do {
            try requestHandler.perform([request])
        } catch {
            print("Error performing OCR request: \(error.localizedDescription)")
        }
    }
    
    func speakText(_ text: String) {
        if !text.isEmpty {
            do {
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(.playback, mode: .default) // Or another appropriate category
                try audioSession.setActive(true)
                
                
            } catch {
                print("Error setting up audio session: \(error)")
            }
            
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR") // Set the language to Brazilian Portuguese
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate // You can adjust the rate
            utterance.pitchMultiplier = 1.0 // You can adjust the pitch
            synthesizer.speak(utterance)
        }
    }
}

#Preview {
    CameraView(image: .constant(nil))
}
