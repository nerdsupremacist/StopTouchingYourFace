
import Foundation
import Combine
import GRDB

class FaceTouchAggregationService {
    private enum State: Equatable {
        case untouched
        case touched(start: Date)
        case touchReleased(start: Date, end: Date)
    }

    private let service: FaceTouchDetector.Service
    private let db: FaceTouchDatabase
    
    let publisher: AnyPublisher<FaceTouch, FaceTouchDetector.Service.Error>

    private var cancellables = Set<AnyCancellable>()

    var faceTouches: [FaceTouch] {
        return db.faceTouches
    }

    init(service: FaceTouchDetector.Service, db: FaceTouchDatabase) {
        self.service = service
        self.db = db
        publisher = service
            .status
            .removeDuplicates()
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.global())
            .removeDuplicates()
            .scan(State.untouched) { previous, status in
                switch (previous, status) {
                case (.touched(let start), .untouchedFace):
                    return .touchReleased(start: start, end: Date())

                case  (.untouched, .faceTouch), (.touchReleased, .faceTouch):
                    return .touched(start: Date())

                case (_, .noFacePresent), (.touched, .faceTouch), (.untouched, .untouchedFace), (.touchReleased, .untouchedFace):
                    return previous

                }
            }
            .compactMap { state in
                guard case .touchReleased(let start, let end) = state else { return nil }
                return FaceTouch(from: start, to: end)
            }
            .eraseToAnyPublisher()

        publisher
            .sink(receiveCompletion: { _ in }) { [unowned self] faceTouch in
                try! self.db.append(faceTouch: faceTouch)
            }
            .store(in: &cancellables)
    }
}
