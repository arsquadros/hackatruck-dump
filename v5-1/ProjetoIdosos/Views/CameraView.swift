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
    @StateObject var viewModel = HeartBeatViewModel()
    
    @State var animationAlert = true

    var body: some View {
        NavigationStack {
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
                    NavBarView()
                    HStack {
                        Text("Camera")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(#colorLiteral(red: 0.2196078431, green: 0.3803921569, blue: 0.3294117647, alpha: 1))) // Darker Green
                            .padding(.vertical)
                        Spacer()
                        // You might have back/cancel buttons here
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        // Check photo library authorization before saving
                        PHPhotoLibrary.requestAuthorization { status in
                            DispatchQueue.main.async {
                                switch status {
                                case .authorized, .limited:
                                    if let savedImage = cameraManager.latestFrame {
                                        performOCR(on: savedImage)
                                        showingOCRResult = true
                                        showingRecognizedText = true
                                    } else {
                                        print("No image to perform OCR on.")
                                    }
                                case .denied, .restricted:
                                    permissionAlertMessage = "Please grant permission to access your Photos library in Settings to enable text recognition."
                                    showPermissionAlert = true
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
                                .background(Color(#colorLiteral(red: 0.6235294118, green: 0.7725490196, blue: 0.6666666667, alpha: 1))) // Light Green
                                .clipShape(Circle())
                        }
                    }
                    .disabled(isSaving || cameraManager.latestFrame == nil) // Disable if saving or no image
                    .padding(.bottom)
                    
                    if showingRecognizedText && !recognizedText.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Texto Reconhecido:")
                                .font(.headline)
                                .foregroundColor(.primary) // Use primary color for better contrast
                                .padding(.top)
                                .padding(.horizontal)
                            ScrollView {
                                Text(recognizedText)
                                    .font(.title3) // Larger font for readability
                                    .foregroundColor(.primary)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))) // Light background
                                    .cornerRadius(8)
                            }
                            .frame(height: 200) // Fixed height for scrollable area
                            .padding(.horizontal)
                            
                            HStack {
                                Spacer()
                                Button("Ouvir Texto") {
                                    speakText(recognizedText)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(#colorLiteral(red: 0.6235294118, green: 0.7725490196, blue: 0.6666666667, alpha: 1))) // Light Green
                                .cornerRadius(8)
                                
                                Button("Apagar Texto") {
                                    recognizedText = ""
                                    showingRecognizedText = false
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.red) // Use a distinct color for destructive action
                                .cornerRadius(8)
                            }
                            .padding(.horizontal)
                        }
                        .background(Color.black.opacity(0.1)) // Subtle background for the recognized text area
                        .cornerRadius(10)
                        .padding()
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
            .background(Color(#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9803921569, alpha: 1))) // Very Light Gray Background
            .navigationBarHidden(true) // Hide default navigation bar
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
