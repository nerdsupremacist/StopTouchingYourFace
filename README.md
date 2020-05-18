# StopTouchingYourFace
SwiftUI App that alerts you when you have touched your face.
This happens to be an App version of my submission for the [WWDC20 Swift Student Challenge](https://developer.apple.com/wwdc20/swift-student-challenge/) 

## How does it work?

Well it uses a small (not great) CoreML Classification Model I created using Microsoft's [Custom Vision](https://www.customvision.ai). That classifies wether or not someone in the picture is touching their face.

Sine my model isn't amazing, I make sure that there's actually a face in the image with Visions [VNDetectFaceRectanglesRequest](https://developer.apple.com/documentation/vision/vndetectfacerectanglesrequest).

And the rest is just pretty SwiftUI code 😍

## Contributions
Contributions are welcome and encouraged!

## Related Work

This is heavily inspired by this [article](https://medium.com/microsoftazure/how-you-can-use-computer-vision-to-avoid-touching-your-face-34a426ffddfd) by [Em Walker](https://twitter.com/lazerwalker).

Similar tools of course exist out there for the web. Most notably [this](https://stopcorona.ai) and [this](https://donottouchyourface.com).

## Learn
This is currenlty a research project. More details about how it works, will be published later.

## License
This App is available under the MIT license. See the LICENSE file for more info.
