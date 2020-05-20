
import SwiftUI

struct StopTouchingYourFace: View {
    @ObservedObject
    var viewModel: StopTouchingYourFaceViewModel

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            BackgroundCircle(color: viewModel.status == .faceTouch ? .red : .green)
                .onlyShow(when: viewModel.status != .noFacePresent)
                .padding(.all, 16)

            NoFacePresentView()
                .onlyShow(when: viewModel.status == .noFacePresent)
                .padding(.all, 16)

            UntouchedFaceView(lastFaceTouch: viewModel.lastFaceTouch)
                .onlyShow(when: viewModel.status == .untouchedFace)
                .padding(.all, 16)

            FaceTouchView()
                .onlyShow(when: viewModel.status == .faceTouch)
                .padding(.all, 16)
        }
        .onAppear { self.viewModel.start() }
    }
}

extension View {

    fileprivate func onlyShow(when show: Bool) -> some View {
        return opacity(show ? 1 : 0)
            .animation(.easeOut(duration: 0.2))
            .scaleEffect(show ? 1 : 0, anchor: .center)
            .animation(.easeInOut(duration: 0.3))
    }

}
