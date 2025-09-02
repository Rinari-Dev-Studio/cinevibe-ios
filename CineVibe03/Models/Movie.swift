import Foundation

struct Movie: Identifiable, Codable {
    var id: Int
    var title: String
    var posterPath: String?
    var overview: String
    var genreIds: [Int]
    
    
    var posterURL: URL? {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        if let path = posterPath {
            return URL(string: baseURL + path)
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case overview
        case genreIds = "genre_ids"
    }
}
