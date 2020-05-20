
import SwiftUI

private let messages = [
    "Don't touch your face",
    "You look soo good. Please don't cover it up with your hands",
    "You really shouldn't touch your face",
    "Please go wash your hands",
    "I worry about you",
    "It's ok to forget. Just try to remember not to touch your face",
    "Please stay safe and don't touch your face",
    "I can see that",
    "Staaaaaahp",
    "Please help me ending this pandemic",
    "Oh my god! What's that on your face?",
    "I feel like you're doing that on purpose 😢",
    "Am I a joke to you?",
    "Do you think this is funny?",
    "If you touch your face less, you help us all slow down the spread",
]

struct FaceTouchView: View {

    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "xmark.shield.fill")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(height: 100)
                .shake()

            QuoteTextView(options: messages).padding(.horizontal, 32)

            Spacer().frame(height: 100)
        }
    }

}
