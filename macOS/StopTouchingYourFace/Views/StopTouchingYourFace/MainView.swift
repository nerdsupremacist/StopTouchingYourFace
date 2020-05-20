
import Foundation
import SwiftUI

struct MainView: View {
    @ObservedObject
    var authorizationViewModel: AuthorizationRequestViewModel

    var stopTouchingYourFaceViewModel: StopTouchingYourFaceViewModel

    var body: some View {
        VStack {
            authorizationViewModel.hasRights ? PopoverView(viewModel: stopTouchingYourFaceViewModel) : nil
            authorizationViewModel.hasRights ? nil : Button("Request Access") { self.authorizationViewModel.requestRightsIfNeeded() }
        }
        .clipped()
    }
}
