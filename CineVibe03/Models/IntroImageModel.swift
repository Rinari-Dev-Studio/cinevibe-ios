import Foundation
import CoreGraphics

struct IntroImageModel: Identifiable {
    let id = UUID()
    let imageName: String
    let xStart: CGFloat
    let yStart: CGFloat
    let delay: Double
}
