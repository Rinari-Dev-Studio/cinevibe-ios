import SwiftUI

struct RecommendationContainer: View {
    let preferredGenres: [Int]
    let userType: UserType
    let userId: String
    @State private var showRating = false
    
    var body: some View {
        TabView {
            Recommendation(preferredGenres: preferredGenres, userType: userType, userId: userId)
                .tabItem {
                    Label("Empfehlungen", systemImage: "star.fill")
                }
            
            Watchlist(userType: userType, userId: userId)
                .tabItem {
                    Label("Watchlist", systemImage: "list.bullet")
                }
            
            Settings()
                .tabItem {
                    Label("Einstellungen", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.blue)
        .fullScreenCover(isPresented: $showRating) {
            Rating(userType: userType, userId: userId)
        }
    }
}
