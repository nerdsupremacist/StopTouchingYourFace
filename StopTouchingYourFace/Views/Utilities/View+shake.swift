
import SwiftUI

extension View {

    func shake(axis: Axis = .horizontal, timeInterval: TimeInterval = 2, shakesPerUnit: Int = 3) -> some View {
        return ShakeView(content: self, axis: axis, timeInterval: timeInterval, shakesPerUnit: shakesPerUnit)
    }

}

private struct ShakeView<Content: View>: View {
    @ObservedObject
    private var viewModel = ShakeViewModel()
    
    var content: Content
    var axis: Axis = .horizontal
    var timeInterval: TimeInterval = 2
    var shakesPerUnit: Int = 3

    var body: some View {
        return content
            .modifier(Shake(axis: axis, shakesPerUnit: shakesPerUnit, animatableData: viewModel.amount))
            .onAppear { self.viewModel.start(timeInterval: self.timeInterval) }
    }

}

private class ShakeViewModel: ObservableObject {
    @Published
    private(set) var amount: CGFloat = 0

    private var timer: Timer?

    deinit {
        timer?.invalidate()
    }

    func start(timeInterval: TimeInterval = 2) {
        timer?.invalidate()
        withAnimation {
            self.amount += 1
        }
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [unowned self] _ in
            withAnimation(.default) {
                self.amount += 1
            }
        }
    }
}

private struct Shake: GeometryEffect {
    var axis: Axis = .horizontal
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        switch axis {
        case .horizontal:
            return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
        case .vertical:
            return ProjectionTransform(CGAffineTransform(translationX: 0, y: translation))
        }
    }
}
