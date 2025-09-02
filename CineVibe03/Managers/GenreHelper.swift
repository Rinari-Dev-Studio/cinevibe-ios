import Foundation

class GenreHelper {
    
    static func filterPreferredGenres(preferredGenreIDs: [Int]) -> [Genre] {
        return Genre.allCases.filter { preferredGenreIDs.contains($0.rawValue) }
    }
    
    
    static func calculatePreferredGenres(from movies: [Movie], likedMovieIDs: [Int]) -> [Int] {
        
        let genreFrequency = movies
            .filter { likedMovieIDs.contains($0.id) }
            .flatMap { $0.genreIds }
            .reduce(into: [Int: Int]()) { counts, genre in
                counts[genre, default: 0] += 1
            }
        
        
        return genreFrequency
            .sorted { $0.value > $1.value }
            .prefix(2)
            .map { $0.key }
    }
}
