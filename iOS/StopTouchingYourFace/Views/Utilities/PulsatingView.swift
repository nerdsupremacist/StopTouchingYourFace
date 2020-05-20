
import SwiftUI

struct PulsatingView: View {
    @State
    private var animatingSmallCircle = false

    @State
    private var animatingMediumCircle = false

    @State
    private var animatingLargeCircle = false

    let color: Color
    var duration: TimeInterval = 4

    var body: some View {
        GeometryReader<AnyView> { proxy in
            let dimension: CGFloat = min(proxy.size.width, proxy.size.height)
            return AnyView(
                ZStack {
                    Circle()
                        .foregroundColor(self.color)
                        .opacity(self.animatingSmallCircle ? 0 : 1)
                        .frame(width: 2 * dimension, height: 2 * dimension, alignment: .center)
                        .scaleEffect(self.animatingLargeCircle ? 1.2 : 0)
                        .animation(Animation.easeOut(duration: self.duration).repeatForever(autoreverses: false).delay(self.duration))
                        .onAppear {
                            self.animatingSmallCircle.toggle()
                        }

                    Circle()
                        .foregroundColor(self.color)
                        .opacity(self.animatingMediumCircle ? 0 : 0.5)
                        .frame(width: 1.5 * dimension, height: 1.5 * dimension, alignment: .center)
                        .scaleEffect(self.animatingLargeCircle ? 1.2 : 0)
                        .animation(Animation.easeOut(duration: self.duration).repeatForever(autoreverses: false).delay(self.duration))
                        .onAppear {
                            self.animatingMediumCircle.toggle()
                        }

                    Circle()
                        .foregroundColor(self.color)
                        .opacity(self.animatingLargeCircle ? 0 : 0.25)
                        .frame(width: dimension, height: dimension, alignment: .center)
                        .scaleEffect(self.animatingLargeCircle ? 1.2 : 0)
                        .animation(Animation.easeOut(duration: self.duration).repeatForever(autoreverses: false).delay(self.duration))
                        .onAppear {
                            self.animatingLargeCircle.toggle()
                        }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            )
        }
    }

}
