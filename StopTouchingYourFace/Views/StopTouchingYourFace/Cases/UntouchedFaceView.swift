
import SwiftUI

private let messages = [
    "Everything is awesome!",
    "You're doing great",
    "Looking good!",
    "You're going to get through this",
    "This pandemic is almost over...",
    "You rock 🤘",
    "You've got this",
    "I believe in you",
    "You're the king/queen of the world!",
    "Have you tried a Zoom game night? They're pretty fun!",
    "Remember: you're not alone",
    "I'm proud of you",
    "Great job!",
    "Everything is fine",
    "Staying virus-free is very cool 😎",
    "Nothing can stop you now!",
    "You're protecting the people you love. I like you",
    "Nice!",
]

struct UntouchedFaceView: View {
    let lastFaceTouch: Date?

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Image(systemName: "hand.thumbsup.fill")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(height: 100)
                    .shake(axis: .vertical, timeInterval: 3, shakesPerUnit: 2)

                QuoteTextView(options: messages).padding(.horizontal, 32)

                Spacer().frame(height: 100)
            }

            lastFaceTouch.map { lastFaceTouch in
                VStack(spacing: 8) {
                    Spacer()

                    Text("You have not touched your face for:")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .lineLimit(nil)
                        .foregroundColor(.white)

                    CountDownLabel(date: lastFaceTouch)
                }
                .padding(.all, 32)
            }
        }
    }
}
