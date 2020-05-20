
import Foundation
import SwiftUI

struct PopoverView: View {
    @ObservedObject
    var viewModel: StopTouchingYourFaceViewModel

    var body: some View {
        VStack(spacing: 0) {
            viewModel.isRunning ? StopTouchingYourFace(viewModel: viewModel).frame(height: 80).clipped() : nil

            List(viewModel.faceTouches.reversed(), id: \.from) { faceTouch in
                FaceTouchCell(faceTouch: faceTouch)
            }

            HStack {
                Button(action: {
                    withAnimation(.easeIn) {
                        self.viewModel.toggle()
                    }
                }) {
                    Image(
                        nsImage: NSImage(
                            named: viewModel.isRunning ? NSImage.touchBarPauseTemplateName : NSImage.touchBarPlayTemplateName
                        )!
                    )
                    .animation(nil)
                }
                Spacer()
                Button("Quit") {
                    self.viewModel.stop()
                    NSApp.terminate(nil)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }.frame(maxHeight: .infinity)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter
}()

private let intervalFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .full
    formatter.includesApproximationPhrase = false
    formatter.includesTimeRemainingPhrase = false
    formatter.allowedUnits = [.day, .hour, .minute, .second]
    return formatter
}()

struct FaceTouchCell: View {
    let faceTouch: FaceTouch

    var body: some View {
        HStack {
            Text("⚠️")
            Text(dateFormatter.string(from: faceTouch.from))
            Spacer()
            intervalFormatter.string(from: max(faceTouch.duration, 1)).map { Text($0) }
        }
    }
}
