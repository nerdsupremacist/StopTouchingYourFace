
import SwiftUI

struct CountDownLabel: View {
    @ObservedObject
    private var viewModel: CountDownLabelViewModel

    init(date: Date) {
        viewModel = CountDownLabelViewModel(date: date)
    }

    var body: some View {
        Text(viewModel.string)
            .font(.headline)
            .fontWeight(.heavy)
            .lineLimit(nil)
            .foregroundColor(.white)
            .animation(nil)
            .onAppear { self.viewModel.start() }
    }
}

private class CountDownLabelViewModel: ObservableObject {
    @Published
    private(set) var string: String = ""

    private let calendar = Calendar(identifier: .gregorian)

    private let date: Date

    private lazy var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter
    }()

    private var timer: Timer?

    init(date: Date) {
        self.date = date
    }

    deinit {
        timer?.invalidate()
    }

    func start() {
        timer?.invalidate()
        update()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] _ in
            self.update()
        }
    }

    private func update() {
        string = formatter.string(from: Date().timeIntervalSince(date)) ?? "Unknown"
    }

}
