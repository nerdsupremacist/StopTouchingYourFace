
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
            HStack(spacing: 8) {
                Text("👍").font(.title).fontWeight(.heavy).foregroundColor(.white).shake(axis: .vertical, timeInterval: 3, shakesPerUnit: 2)

                QuoteTextView(options: messages)

                Spacer()

                lastFaceTouch.map { lastFaceTouch in
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("You have not touched your face for:")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .lineLimit(nil)
                            .foregroundColor(.white)

                        CountDownLabel(date: lastFaceTouch)
                    }.frame(minHeight: 80, idealHeight: 80, maxHeight: 160)
                }
            }
        }
    }
}
