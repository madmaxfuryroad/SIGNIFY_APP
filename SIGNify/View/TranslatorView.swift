import SwiftUI
import AVFoundation
import Vision
import CoreML

final class CameraViewModel: NSObject, ObservableObject {
    @Published var lastPrediction: String = ""
    @Published var message: [String] = []

    // Exposed so CameraPreview can use it
    let session = AVCaptureSession()
    private let sequenceHandler = VNSequenceRequestHandler() //helper object
    private var request: VNCoreMLRequest!

    // For buffering: last thing appended & when
    private var lastAppendedLetter: String = ""
    private var lastAppendTime: Date = .distantPast

    override init() {
        super.init()
        configureModel()
        configureCamera()
    }

    func startSession() {
        guard !session.isRunning else { return }
        session.startRunning()
    }

    func stopSession() {
        guard session.isRunning else { return }
        session.stopRunning()
    }

    private func configureModel() {
        let config = MLModelConfiguration()
        // ← Replace `MyHandPoseClassifier` with your generated model class
        guard let classifier = try? TESTING2(configuration: config),
              let visionModel = try? VNCoreMLModel(for: classifier.model)
        else {
            fatalError("Could not load ML model")
        }
        request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
        request.imageCropAndScaleOption = .centerCrop
    }

    private func visionRequestDidComplete(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation],
              let best = results.first else { return }
        let rawLetter = best.identifier.uppercased()
        let confidence = best.confidence
        DispatchQueue.main.async {
            self.lastPrediction = rawLetter
            self.maybeAppend(letter: rawLetter, confidence: confidence)
        }
    }

    private func maybeAppend(letter: String, confidence: VNConfidence) {
        let now = Date()
        let threshold: VNConfidence = 0.8
        let toAppend = (confidence < threshold) ? " " : letter
        let timeGap = now.timeIntervalSince(lastAppendTime)
        let didChange = (toAppend != lastAppendedLetter)

        if didChange || timeGap > 3.0 {
            lastAppendedLetter = toAppend
            lastAppendTime = now

            message.append(toAppend)
            if message.count > 30 {
                message.removeFirst(message.count - 30)
            }
        }
    }

    private func configureCamera() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        // Input
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .front),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input)
        else { return }
        session.addInput(input)

        // Output
        let output = AVCaptureVideoDataOutput()
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.output"))
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)

        session.commitConfiguration()
    }
}

extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        try? sequenceHandler.perform([request], on: pixelBuffer)
    }
}

// ─── UIViewRepresentable: Live camera preview ───────────────────────────────────────
struct CameraPreview: UIViewRepresentable {
    class PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var videoLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }

    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoLayer.session = session
        view.videoLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {}
}

// ─── UIViewRepresentable: Blur background for message bar ─────────────────────────
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// ─── Main SwiftUI View ────────────────────────────────────────────────────────────
struct TranslatorView: View {
    @StateObject private var vm = CameraViewModel()
    @State private var showCamera = false
    @State private var showPermissionAlert = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            if showCamera {
                ZStack {
                    // Camera feed
                    CameraPreview(session: vm.session)
                        .ignoresSafeArea()

                    VStack {
                        // Top bar: title + clear button
                        HStack {
                            Text("SiGNify ASL")
                                .font(.title2).bold()
                                .foregroundColor(.white)
                            Spacer()
                            Button {
                                vm.message.removeAll()
                                vm.lastPrediction = ""
                            } label: {
                                Image(systemName: "trash.fill")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top, 40)

                        Spacer()

                        // Current letter bubble
                        VStack(spacing: 8) {
                            Text(vm.lastPrediction)
                                .font(.system(size: 72, weight: .bold))
                                .foregroundColor(.white)
                            Text("Detected: \(vm.lastPrediction)")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 40)
                        .background(Color.green.opacity(0.75))
                        .cornerRadius(25)
                        .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 5)

                        Spacer()

                        // Bottom message bar
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(Array(vm.message.enumerated()), id: \.offset) { idx, letter in
                                    Text(letter)
                                        .font(.title3).bold()
                                        .padding(8)
                                        .background(Color.white.opacity(0.85))
                                        .foregroundColor(.black)
                                        .cornerRadius(8)
                                        .opacity(1.0 - (Double(vm.message.count - 1 - idx) * 0.02))
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .background(BlurView(style: .systemThinMaterial))
                            .cornerRadius(25)
                            .padding(.bottom, 30)
                        }
                    }
                }
            } else {
                // Entry screen
                VStack(spacing: 24) {
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                    Text("SiGNify")
                        .font(.largeTitle).bold()
                        .foregroundColor(.green)
                    Button {
                        checkCameraPermission()
                    } label: {
                        Label("Access Camera", systemImage: "camera.fill")
                            .font(.title2)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 24)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: Color.green.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
                }
            }
        }
        .alert(isPresented: $showPermissionAlert) {
            Alert(title: Text("Camera Access Needed"),
                  message: Text("Please enable camera access in Settings so SiGNify can translate ASL."),
                  primaryButton: .default(Text("Open Settings")) {
                      UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                  },
                  secondaryButton: .cancel()
            )
        }
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showCamera = true
            vm.startSession()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        showCamera = true
                        vm.startSession()
                    } else {
                        showPermissionAlert = true
                    }
                }
            }

        default:
            showPermissionAlert = true
        }
    }
}

#Preview {
    TranslatorView()
}
