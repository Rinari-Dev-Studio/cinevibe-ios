import SwiftUI

struct CustomMenu: View {
    @Binding var isMenuVisible: Bool
    @Binding var selectedGenre: Int?
    let genres: [Genre]
    let onGenreSelect: (Int?) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Button("Alle Genres") {
                onGenreSelect(nil)
            }
            .foregroundColor(.blue)
            .font(.title3)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(selectedGenre == nil ? Color.blue.opacity(0.2) : Color.clear)
            .cornerRadius(5)
            
            Divider()
                .background(Color.gray)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(genres) { genre in
                        Button(genre.name) {
                            onGenreSelect(genre.id)
                        }
                        .foregroundColor(.blue)
                        .font(.title3)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(selectedGenre == genre.id ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(5)
                        
                        Divider()
                            .background(Color.gray)
                    }
                }
            }
            .frame(maxHeight: 300)
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(8)
        .shadow(radius: 5)
        .frame(maxWidth: 200)
    }
}

