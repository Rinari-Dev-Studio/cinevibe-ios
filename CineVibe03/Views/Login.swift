import SwiftUI

struct Login: View {
    @StateObject private var viewModel = LoginViewModel()
    @StateObject private var userSelectionViewModel = UserSelectionViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showUserSelection = false
    @State private var moveTitleUp = false
    @State private var showRegistration = false
    @State private var fadeOutSubtitle = false
    @State private var showLoginForm = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if showUserSelection {
                UserSelection(viewModel: userSelectionViewModel)
                    .environmentObject(appViewModel)
            } else {
                VStack(spacing: 10) {
                    
                    Text("CineVibe")
                        .font(Font.custom("SinhalaSangamMN", size: 64))
                        .kerning(0.64)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.clear)
                        .overlay(
                            LinearGradient(gradient: Gradient(colors: [
                                Color(red: 0.2, green: 0.4, blue: 1.0),
                                Color(red: 0.6, green: 0.8, blue: 1.0)
                            ]), startPoint: .top, endPoint: .bottom)
                            .mask(
                                Text("CineVibe")
                                    .font(Font.custom("SinhalaSangamMN", size: 64))
                                    .kerning(0.64)
                            )
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 2, y: 2)
                        .overlay(
                            Text("CineVibe")
                                .font(Font.custom("SinhalaSangamMN", size: 64))
                                .kerning(0.64)
                                .foregroundColor(.white.opacity(0.4))
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(Rectangle().padding(-1))
                        )
                        .frame(width: 298, height: 86, alignment: .center)
                        .padding(.bottom, moveTitleUp ? 20 : 5)
                        .offset(y: moveTitleUp ? -UIScreen.main.bounds.height / 4 : -40)
                        .animation(.easeInOut(duration: 1.9), value: moveTitleUp)
                    
                    
                    
                    if !fadeOutSubtitle {
                        Text("Einfach gute Filme finden")
                            .font(.title2)
                            .foregroundColor(.clear)
                            .overlay(
                                LinearGradient(gradient: Gradient(colors: [
                                    Color(red: 0.4, green: 0.7, blue: 1.0),
                                    Color(red: 0.8, green: 0.9, blue: 1.0)
                                ]), startPoint: .top, endPoint: .bottom)
                                .mask(
                                    Text("Einfach gute Filme finden")
                                        .font(.title2)
                                )
                            )
                            .offset(y: -70)
                            .animation(.easeInOut(duration: 1.5), value: fadeOutSubtitle)
                    }
                }
                .padding()
                .onAppear {
                    Task {
                        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                        withAnimation {
                            moveTitleUp = true
                        }
                        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
                        withAnimation {
                            fadeOutSubtitle = true
                        }
                        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
                        withAnimation {
                            showLoginForm = true
                        }
                    }
                }
                
                if showLoginForm {
                    loginForm
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 1.5), value: showLoginForm)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("UserLoggedOut"))) { _ in
            resetToLogin()
        }
        .sheet(isPresented: $showRegistration) {
            Registration(isPresented: $showRegistration)
        }
    }
    
    private var loginForm: some View {
        VStack(spacing: 10) {
            TextField("E-Mail", text: $viewModel.email)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                )
                .foregroundColor(.white)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .frame(width: 280)
            
            SecureField("Passwort", text: $viewModel.password)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                )
                .foregroundColor(.white)
                .frame(width: 280)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Button(action: {
                Task {
                    await viewModel.loginWithEmail(appViewModel: appViewModel)
                    if viewModel.isAuthenticated {
                        showUserSelection = true
                    }
                }
            }) {
                Text("Anmelden")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: 280)
                    .cornerRadius(12)
                    .foregroundColor(.green)
            }
            .foregroundColor(.blue)
            .padding()
            
            Button("Registrieren") {
                showRegistration.toggle()
            }
            .foregroundColor(.blue)
        }
        .padding()
    }
    
    private func resetToLogin() {
        showUserSelection = false
        moveTitleUp = false
        fadeOutSubtitle = false
        showLoginForm = false
    }
    
}
