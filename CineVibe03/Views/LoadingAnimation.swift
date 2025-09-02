import SwiftUI

struct LoadingAnimation: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ForEach(0..<5) { i in
                Circle()
                    .stroke(Color.cyan.opacity(0.5), lineWidth: 2)
                    .frame(width: animate ? CGFloat(100 + i * 50) : 0, height: animate ? CGFloat(100 + i * 50) : 0)
                    .scaleEffect(animate ? 1 : 0)
                    .opacity(animate ? 0 : 1)
                    .animation(
                        Animation.easeOut(duration: 1.5)
                            .repeatForever(autoreverses: false)
                            .delay(Double(i) * 0.3), value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}
