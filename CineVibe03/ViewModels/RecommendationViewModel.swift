import Foundation
import SwiftUI

@MainActor
class RecommendationViewModel: ObservableObject {
    @Published var recommendedMovies: [Movie] = []
    @Published var showAddedNotification = false
    @Published var addedMovieTitle = ""
    
    private var isMoviesLoaded = false
    private let preferredGenres: [Int]
    private let userType: UserType
    private let userId: String
    private let movieService = MovieAPI()
    private let watchlistViewModel = WatchlistViewModel()
    
    init(preferredGenres: [Int], userType: UserType, userId: String) {
        self.preferredGenres = preferredGenres
        self.userType = userType
        self.userId = userId
    }
    
    func loadRecommendedMovies() async {
        guard !isMoviesLoaded else { return }
        do {
            let genres = GenreHelper.filterPreferredGenres(preferredGenreIDs: preferredGenres)
            self.recommendedMovies = try await movieService.fetchMoviesByGenres(genres: genres, count: 10)
            isMoviesLoaded = true
        } catch {
            print("Fehler beim Laden der empfohlenen Filme.")
        }
    }
    
    func resetRecommendations() {
        self.recommendedMovies = []
        self.isMoviesLoaded = false
    }
    
    func addToWatchlist(movie: Movie, userType: UserType, userId: String) async throws {
        try await watchlistViewModel.addToWatchlist(movie: movie, userType: userType, userId: userId)
        addedMovieTitle = movie.title
        showAddedNotification = true
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        showAddedNotification = false
    }
}
