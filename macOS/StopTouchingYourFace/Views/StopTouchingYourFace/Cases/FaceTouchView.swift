
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
        HStack(spacing: 8) {
            Text("🚨").font(.title).fontWeight(.heavy).foregroundColor(.white).shake(axis: .horizontal, timeInterval: 3, shakesPerUnit: 2)

            QuoteTextView(options: messages)

            Spacer()
        }
    }

}
