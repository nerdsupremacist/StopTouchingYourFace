
import SwiftUI
import Combine
import AVFoundation
import AVKit

class StopTouchingYourFaceViewModel: ObservableObject {
    private let manager = FaceTouchDetector.Service()

    @Published
    private(set) var status: FaceTouchDetector.Status = .noFacePresent

    @Published
    private(set) var error: Error?

    @Published
    private(set) var lastFaceTouch: Date? = nil

    private var cancellables = Set<AnyCancellable>()

    init() {
        manager
            .status
            .removeDuplicates()
            .debounce(for: .seconds(0.35), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveCompletion: { [unowned self] completion in
                guard case .failure(let error) = completion else { return }
                switch error {
                case .visionError(let error):
                    print("An Error with Vision ocurred: \(error)")
                    self.error = error

                case .captureSessionError(let error):
                    print("An Error with the Capture Session ocurred: \(error)")
                    self.error = error

                case .permissionError(let error):
                    print("An Error with permissions ocurred: \(error)")
                    self.error = error

                }
            }) { [unowned self] status in
                self.status = status
                switch status {

                case .faceTouch:
                    self.lastFaceTouch = nil

                case .untouchedFace where self.lastFaceTouch == nil:
                    self.lastFaceTouch = Date()

                case .noFacePresent, .untouchedFace:
                    break

                }
            }
            .store(in: &cancellables)
    }

    func start() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .front)

        guard let device = discoverySession.devices.first else { return }
        manager.start(device: device)
    }
}
