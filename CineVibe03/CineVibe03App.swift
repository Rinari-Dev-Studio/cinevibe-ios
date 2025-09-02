import SwiftUI

@main
struct CineVibe03App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appViewModel = AppViewModel()
    
    init() {
        configureTabBarAppearance()
        
    }
    
    var body: some Scene {
        WindowGroup {
            Intro()
                .environmentObject(appViewModel)
        }
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
