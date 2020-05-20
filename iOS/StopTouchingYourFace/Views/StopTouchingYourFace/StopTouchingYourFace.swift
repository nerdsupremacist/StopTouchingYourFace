
import SwiftUI

struct StopTouchingYourFace: View {
    @ObservedObject
    var viewModel = StopTouchingYourFaceViewModel()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            BackgroundCircle(color: viewModel.status == .faceTouch ? .red : .green)
                .onlyShow(when: viewModel.status != .noFacePresent)

            NoFacePresentView()
                .onlyShow(when: viewModel.status == .noFacePresent)

            UntouchedFaceView(lastFaceTouch: viewModel.lastFaceTouch)
                .onlyShow(when: viewModel.status == .untouchedFace)

            FaceTouchView()
                .onlyShow(when: viewModel.status == .faceTouch)
        }
        .onAppear { self.viewModel.start() }
    }
}

extension View {

    fileprivate func onlyShow(when show: Bool) -> some View {
        return show ? AnimateAppearence(content: self) : nil
    }

}

private struct AnimateAppearence<Content: View>: View {
    let content: Content

    @State
    private var animating: Bool = false

    var body: some View {
        content
            .opacity(animating ? 1 : 0)
            .animation(.easeOut(duration: 0.2))
            .scaleEffect(animating ? 1 : 0, anchor: .center)
            .animation(.easeInOut(duration: 0.3))
            .onAppear {
                self.animating.toggle()
            }
    }
}

