
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
        ZStack {
            PulsatingView(color: Color.white).opacity(0.5)

            QuoteTextView(options: messages).padding(.horizontal, 32)
        }
    }
}
