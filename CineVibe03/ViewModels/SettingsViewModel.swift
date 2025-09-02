import Foundation

class SettingsViewModel: ObservableObject {
    func restartRating() {
        NotificationCenter.default.post(name: Notification.Name("ResetRecommendations"), object: nil)
    }
    
    func logout(appViewModel: AppViewModel) {
        appViewModel.logOut()
        NotificationCenter.default.post(name: Notification.Name("UserLoggedOut"), object: nil)
    }
    
    func switchUser(appViewModel: AppViewModel) {
        NotificationCenter.default.post(name: Notification.Name("SwitchUser"), object: nil)
    }
}
