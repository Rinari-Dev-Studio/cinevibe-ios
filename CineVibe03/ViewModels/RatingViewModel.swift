import Foundation
import SwiftUI

@MainActor
class RatingViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var currentIndex: Int = 0
    @Published var offset: CGFloat = 0.0
    @Published var showRecommendations: Bool = false
    @Published var preferredGenres: [Int] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let storage = RatingStorage()
    private let movieService = MovieAPI()
    
    
    var currentMovie: Movie? {
        guard currentIndex < movies.count else { return nil }
        return movies[currentIndex]
    }
    
    
    func loadMovies(random: Bool = true) async {
        isLoading = true
        errorMessage = nil
        do {
            if random {
                movies = try await movieService.fetchRandomMovies(count: 10)
            } else {
                let preferredGenreIDs = getPreferredGenres()
                let preferredGenres = GenreHelper.filterPreferredGenres(preferredGenreIDs: preferredGenreIDs)
                movies = try await movieService.fetchMoviesByGenres(genres: preferredGenres, count: 5)
            }
            currentIndex = 0
        } catch {
            errorMessage = "error laden filme: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    
    func updateGestureOffset(_ offset: CGFloat) {
        self.offset = offset
    }
    
    
    func handleSwipeGesture(_ offset: CGFloat) {
        if offset > 100 {
            handleSwipe(like: true)
        } else if offset < -100 {
            handleSwipe(like: false)
        }
        self.offset = 0
    }
    
    
    private func handleSwipe(like: Bool) {
        guard currentIndex < movies.count else { return }
        let movie = movies[currentIndex]
        
        if like {
            storage.saveRating(movieId: movie.id, liked: true)
        }
        
        currentIndex += 1
        
        if currentIndex >= movies.count {
            preferredGenres = getPreferredGenres()
            showRecommendations = true
        }
    }
    
    
    private func getPreferredGenres() -> [Int] {
        let likedMovies = storage.getRatings().compactMap { $0.key }
        return GenreHelper.calculatePreferredGenres(from: movies, likedMovieIDs: likedMovies)
    }
}
