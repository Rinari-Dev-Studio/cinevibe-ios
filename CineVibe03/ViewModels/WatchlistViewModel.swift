import FirebaseFirestore
import SwiftUI

class WatchlistViewModel: ObservableObject {
    @Published var watchlist: [Movie] = []
    @Published var filteredWatchlist: [Movie] = []
    @Published var selectedGenre: Int? = nil
    
    private let db = Firestore.firestore()
    
    private func watchlistRef(for userType: UserType, userId: String) -> CollectionReference {
        switch userType {
        case .mainUser:
            return db.collection("users").document(userId).collection("watchlist")
        case .familyMember(let familyMemberId):
            return db.collection("users").document(userId).collection("family").document(familyMemberId).collection("watchlist")
        }
    }
    
    func addToWatchlist(movie: Movie, userType: UserType, userId: String) async throws {
        let watchlistRef = watchlistRef(for: userType, userId: userId)
        try await watchlistRef.document("\(movie.id)").setData(movie.toDictionary())
        print("Film zur Watchlist hinzugefügt.")
    }
    
    func removeFromWatchlist(movie: Movie, userType: UserType, userId: String) async {
        let watchlistRef = watchlistRef(for: userType, userId: userId)
        
        do {
            try await watchlistRef.document("\(movie.id)").delete()
            await MainActor.run {
                self.watchlist.removeAll { $0.id == movie.id }
                self.filteredWatchlist.removeAll { $0.id == movie.id }
            }
            print("Film aus der Watchlist entfernt.")
        } catch {
            print("Fehler beim Entfernen: \(error.localizedDescription)")
        }
    }
    
    func fetchWatchlist(for userType: UserType, userId: String) async {
        let watchlistRef = watchlistRef(for: userType, userId: userId)
        
        do {
            let snapshot = try await watchlistRef.getDocuments()
            let loadedWatchlist = snapshot.documents.compactMap { document in
                Movie.fromFirestore(document: document)
            }
            
            await MainActor.run {
                self.watchlist = loadedWatchlist
                self.applyFilter()
            }
            print("Watchlist erfolgreich abgerufen.")
        } catch {
            print("Fehler beim Abrufen der Watchlist: \(error.localizedDescription)")
            await MainActor.run {
                self.watchlist = []
            }
        }
    }
    
    func applyFilter() {
        if let genre = selectedGenre {
            print("Filtern der Watchlist nach Genre-ID: \(genre)")
            filteredWatchlist = watchlist.filter { $0.genreIds.contains(genre) }
        } else {
            print("Keine Filter angewendet. Zeige gesamte Watchlist.")
            filteredWatchlist = watchlist
        }
    }
    
    func genreName(for genreId: Int) -> String {
        return Genre.name(for: genreId)
    }
}

extension Movie {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "overview": overview,
            "posterPath": posterPath ?? "",
            "genreIds": genreIds
        ]
    }
    
    static func fromFirestore(document: DocumentSnapshot) -> Movie? {
        guard let data = document.data(),
              let id = Int(document.documentID),
              let title = data["title"] as? String,
              let overview = data["overview"] as? String,
              let posterPath = data["posterPath"] as? String,
              let genreIds = data["genreIds"] as? [Int] else {
            print("Fehler beim Konvertieren von Firestore-Daten: \(document.documentID)")
            return nil
        }
        return Movie(
            id: id,
            title: title,
            posterPath: posterPath,
            overview: overview,
            genreIds: genreIds
        )
    }
}
