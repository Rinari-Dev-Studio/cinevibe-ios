import SwiftUI

struct Registration: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @Binding var isPresented: Bool
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showRating = false
    @State private var showLoginScreen = false
    
    var body: some View {
        ZStack {
            if showRating, let userId = appViewModel.userId {
                Rating(userType: .mainUser, userId: userId)
            } else if showLoginScreen {
                Login()
                    .environmentObject(appViewModel)
            } else {
                registrationForm
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("UserLoggedOut"))) { _ in
            handleLogout()
        }
    }
    
    private var registrationForm: some View {
        Form {
            Section(header: Text("Persönliche Informationen")) {
                TextField("Vorname", text: $viewModel.firstname)
                TextField("Nachname", text: $viewModel.lastname)
                DatePicker("Geburtsdatum", selection: $viewModel.birthdate, displayedComponents: .date)
                TextField("E-Mail", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            Section(header: Text("Passwort")) {
                SecureField("Passwort", text: $viewModel.password)
                    .textContentType(.newPassword)
                    .autocapitalization(.none)
                
                SecureField("Passwort bestätigen", text: $viewModel.confirmPassword)
                    .textContentType(.newPassword)
                    .autocapitalization(.none)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Button("Registrieren") {
                Task {
                    await viewModel.registerUser(appViewModel: appViewModel)
                    if viewModel.isRegistered {
                        showRating = true
                    }
                }
            }
            .disabled(viewModel.isFormInvalid)
            
            Button("Abbrechen") {
                isPresented = false
            }
            .foregroundColor(.red)
        }
        .navigationBarTitle("Registrierung", displayMode: .inline)
    }
    
    private func handleLogout() {
        
        showRating = false
        showLoginScreen = true
        print("Benutzer wurde ausgeloggt. Zurück zur Login-Seite.")
    }
}
