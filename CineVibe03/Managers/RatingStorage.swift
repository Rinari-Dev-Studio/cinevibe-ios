import Foundation

class RatingStorage {
    private var ratings: [Int: Bool] = [:]
    
    func saveRating(movieId: Int, liked: Bool) {
        ratings[movieId] = true
    }
    
    func getRatings() -> [Int: Bool] {
        return ratings
    }
}

