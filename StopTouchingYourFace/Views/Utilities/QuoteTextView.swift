
import SwiftUI

struct QuoteTextView: View {
    @ObservedObject
    private var viewModel: QuoteTextViewModel

    init(options: [String]) {
        viewModel = QuoteTextViewModel(options: options)
    }

    var body: some View {
        return Text(viewModel.current)
            .font(.largeTitle)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .lineLimit(5)
            .fixedSize(horizontal: false, vertical: true)
            .onAppear {
                self.viewModel.start()
            }
    }
}

private class QuoteTextViewModel: ObservableObject {
    @Published
    var current: String

    private let options: [String]
    private var timer: Timer?

    init(options: [String]) {
        current = options.randomElement()!
        self.options = options
    }

    deinit {
        timer?.invalidate()
    }

    func start(timeInterval: TimeInterval = 8) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [unowned self] _ in
            withAnimation(.default) {
                self.current = self.options.randomElement()!
            }
        }
    }
}
