import SwiftUI
import CoreGraphics

@MainActor
class IntroViewModel: ObservableObject {
    @Published var showLoginScreen = false
    @Published var imageStates: [UUID: (animate: Bool, fadeOut: Bool)] = [:]
    
    let imageModels: [IntroImageModel] = [
        IntroImageModel(imageName: "Cover1", xStart: 450, yStart: 450, delay: 0.1),
        IntroImageModel(imageName: "Cover2", xStart: 500, yStart: 700, delay: 0.2),
        IntroImageModel(imageName: "Cover3", xStart: 550, yStart: -450, delay: 0.3),
        IntroImageModel(imageName: "Cover4", xStart: -500, yStart: 400, delay: 0.4),
        IntroImageModel(imageName: "Cover5", xStart: 500, yStart: -400, delay: 0),
        IntroImageModel(imageName: "Cover6", xStart: -550, yStart: 450, delay: 0.7),
        IntroImageModel(imageName: "Cover7", xStart: -620, yStart: -320, delay: 0.9),
        IntroImageModel(imageName: "Cover8", xStart: 0, yStart: -750, delay: 0.8),
        IntroImageModel(imageName: "Cover9", xStart: -200, yStart: 490, delay: 1.0)
    ]
    
    
    init() {
        for model in imageModels {
            imageStates[model.id] = (animate: false, fadeOut: false)
        }
    }
    
    func startAnimations() {
        Task {
            for model in imageModels {
                
                Task {
                    await animateImage(with: model)
                }
                try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            }
            await navigateToLoginAfterDelay()
        }
    }
    
    
    private func animateImage(with model: IntroImageModel) async {
        try? await Task.sleep(nanoseconds: UInt64(model.delay * 9_000_000_00))
        
        
        await MainActor.run {
            self.imageStates[model.id]?.animate = true
        }
        try? await Task.sleep(nanoseconds: 2 * 2_000_000_000)
        
        await MainActor.run {
            withAnimation(Animation.easeInOut(duration: 3)) {
                self.imageStates[model.id]?.fadeOut = true
            }
        }
    }
    
    private func navigateToLoginAfterDelay() async {
        try? await Task.sleep(nanoseconds: 7 * 1_000_000_000)
        
        await MainActor.run {
            self.showLoginScreen = true
        }
    }
}
