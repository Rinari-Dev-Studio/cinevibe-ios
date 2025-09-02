import SwiftUI

struct Settings: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showLogoutConfirmation = false
    @State private var showSwitchUser = false
    @State private var showRating = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section {
                        Button("Neues Rating starten") {
                            viewModel.restartRating()
                            showRating = true
                        }
                        .foregroundColor(.blue)
                        
                        Button("Benutzer wechseln") {
                            viewModel.switchUser(appViewModel: appViewModel)
                            showSwitchUser = true
                        }
                        .foregroundColor(.blue)
                        
                        Button("Logout / Benutzer wechseln") {
                            showLogoutConfirmation = true
                        }
                        .foregroundColor(.red)
                        .alert(isPresented: $showLogoutConfirmation) {
                            Alert(
                                title: Text("Abmelden"),
                                message: Text("Möchten Sie sich wirklich abmelden?"),
                                primaryButton: .destructive(Text("Abmelden")) {
                                    handleLogout()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
                .navigationTitle("Einstellungen")
            }
            .fullScreenCover(isPresented: $showRating) {
                Rating(
                    userType: appViewModel.userType,
                    userId: appViewModel.userId ?? ""
                )
            }
            .fullScreenCover(isPresented: $showSwitchUser) {
                UserSelection()
                    .environmentObject(appViewModel)
            }
        }
    }
    
    private func handleLogout() {
        viewModel.logout(appViewModel: appViewModel)
    }
}
