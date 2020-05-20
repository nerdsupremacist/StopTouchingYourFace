
import SwiftUI

private let messages = [
    "I can't see you",
    "Where are you?",
    "Hope you're staying safe",
    "I miss you",
    "Please join me!",
    "Don't wanna be ALL BY myyyyyyseeeeelf 🎵",
    "It's lonely here",
    "Hello?",
    "Looooooonelyyyyyy 🎵",
    "Anybody there?",
    "I need social contact...",
]

struct NoFacePresentView: View {
    var body: some View {
        HStack(spacing: 8) {
            Text("👀").font(.title).fontWeight(.heavy).foregroundColor(.white).shake(axis: .horizontal, timeInterval: 3, shakesPerUnit: 2)

            QuoteTextView(options: messages)

            Spacer()
        }
    }
}
