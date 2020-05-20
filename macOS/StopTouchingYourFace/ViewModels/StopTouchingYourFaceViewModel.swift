
import SwiftUI
import Combine
import AVFoundation
import AVKit

class StopTouchingYourFaceViewModel: ObservableObject {
    private let faceDetectionService: FaceTouchDetector.Service
    private let faceTouchAggregationService: FaceTouchAggregationService

    var frameRate: Double? = nil {
        didSet {
            if isRunning {
                startService()
            }
        }
    }

    @Published
    private(set) var faceTouches: [FaceTouch]

    @Published
    private(set) var status: FaceTouchDetector.Status = .noFacePresent

    @Published
    private(set) var error: Error?

    @Published
    private(set) var lastFaceTouch: Date? = nil

    @Published
    private(set) var isRunning = false

    private var cancellables = Set<AnyCancellable>()

    init(faceDetectionService: FaceTouchDetector.Service, faceTouchAggregationService: FaceTouchAggregationService) {
        self.faceDetectionService = faceDetectionService
        self.faceTouchAggregationService = faceTouchAggregationService
        self.faceTouches = faceTouchAggregationService.faceTouches

        faceDetectionService
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

        faceTouchAggregationService
            .publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { [unowned self] faceTouch in
                withAnimation(.easeIn) {
                    self.faceTouches.append(faceTouch)
                }
            }
            .store(in: &cancellables)
    }

    func start() {
        guard !isRunning else { return }
        startService()
    }

    func stop() {
        guard isRunning else { return }
        isRunning = false
        status = .noFacePresent
        faceDetectionService.stop()
    }

    func toggle() {
        if isRunning {
            stop()
        } else {
            start()
        }
    }

    private func startService() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        isRunning = true
        faceDetectionService.start(device: device, frameRate: frameRate)
    }
}
