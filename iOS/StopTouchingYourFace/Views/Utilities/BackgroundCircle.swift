
import SwiftUI

struct BackgroundCircle: View {
    let color: Color

    var body: some View {
        GeometryReader<AnyView> { proxy in
            let dimension = 2 * max(proxy.size.width, proxy.size.height)
            return AnyView(
                Circle()
                    .fill(self.color)
                    .frame(width: dimension, height: dimension)
                    .offset(x: -dimension / 4, y: -dimension / 4)
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}
