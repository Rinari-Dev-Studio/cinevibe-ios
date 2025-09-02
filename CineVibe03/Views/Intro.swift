import SwiftUI

struct Intro: View {
    @StateObject private var viewModel = IntroViewModel()
    private let audioManager = Audio()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            
            ForEach(viewModel.imageModels) { model in
                IntroImage(model: model, animate: viewModel.imageStates[model.id]?.animate ?? false, fadeOut: viewModel.imageStates[model.id]?.fadeOut ?? false)
            }
            
            
            if viewModel.showLoginScreen {
                Login()
                    .transition(.opacity)
            }
        }
        .onAppear {
            viewModel.startAnimations()
            
            Task {
                try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                audioManager.playIntroSound()
            }
            
        }
    }
}

struct IntroImage: View {
    let model: IntroImageModel
    let animate: Bool
    let fadeOut: Bool
    
    var body: some View {
        Image(model.imageName)
            .resizable()
            .frame(width: 190, height: 190)
            .opacity(fadeOut ? 0 : 1)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.cyan.opacity(0.2), lineWidth: 2)
                    .blur(radius: 10)
            )
            .scaleEffect(animate ? 4.0 : 0.2)
            .rotationEffect(.degrees(Double.random(in: -20...20)))
            .offset(x: animate ? CGFloat.random(in: -50...50) : model.xStart,
                    y: animate ? CGFloat.random(in: -50...50) : model.yStart * 1.9)
            .animation(Animation.easeInOut(duration: 6).delay(model.delay), value: animate)
    }
}
