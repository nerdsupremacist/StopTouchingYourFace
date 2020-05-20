
import Foundation
import AVKit

class AuthorizationRequestViewModel: ObservableObject {
    @Published
    private(set) var hasRights: Bool

    init() {
        hasRights = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }

    func requestRightsIfNeeded() {
        guard !hasRights else { return }
        AVCaptureDevice.requestAccess(for: .video) { [weak self] hasRights in
            DispatchQueue.main.async { [weak self] in
                self?.hasRights = hasRights
            }
        }
    }
}
