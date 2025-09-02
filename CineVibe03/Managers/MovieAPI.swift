import Foundation

class MovieAPI {
    private let apiKey = "DEIN KEY"
    private let baseURL = "https://api.themoviedb.org/3"
    
    
    
    func fetchRandomMovies(count: Int) async throws -> [Movie] {
        let randomPage = Int.random(in: 1...150)
        let urlString = "\(baseURL)/discover/movie?api_key=\(apiKey)&sort_by=popularity.desc&page=\(randomPage)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        print("API-Daten: \(String(data: data, encoding: .utf8) ?? "Keine Daten")")
        let response = try JSONDecoder().decode(MovieResponse.self, from: data)
        print("Dekodierte Filme: \(response.results)")
        
        return Array(response.results.shuffled().prefix(count))
    }
    
    
    
    func fetchMoviesByGenres(genres: [Genre], count: Int) async throws -> [Movie] {
        let genreString = genres.map { String($0.rawValue) }.joined(separator: ",")
        let randomPage = Int.random(in: 1...150)
        
        let urlString = "\(baseURL)/discover/movie?api_key=\(apiKey)&with_genres=\(genreString)&page=\(randomPage)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MovieResponse.self, from: data)
        return Array(response.results.shuffled().prefix(count))
    }
}

