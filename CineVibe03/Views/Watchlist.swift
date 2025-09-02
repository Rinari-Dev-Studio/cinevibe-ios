import SwiftUI


struct Watchlist: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = WatchlistViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var isMenuVisible = false
    @State private var isLoading = true
    
    let userType: UserType
    let userId: String
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .onTapGesture {
                    isMenuVisible = false
                }
            
            if isLoading {
                LoadingAnimation()
            } else {
                VStack {
                    
                    HStack {
                        if appViewModel.isNavigatedFromUserSelection {
                            Button(action: {
                                appViewModel.isNavigatedFromUserSelection = false
                                dismiss()
                            }) {
                                Image(systemName: "arrow.backward")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                            }
                            .padding(.leading, 10)
                        }
                        
                        Spacer()
                        
                        Text("Watchlist")
                            .font(Font.custom("SinhalaSangamMN", size: 47)) 
                            .kerning(0.64)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.clear)
                            .overlay(
                                LinearGradient(gradient: Gradient(colors: [
                                    Color(red: 0.2, green: 0.4, blue: 1.0),
                                    Color(red: 0.6, green: 0.8, blue: 1.0)
                                ]), startPoint: .top, endPoint: .bottom)
                                .mask(
                                    Text("Watchlist")
                                        .font(Font.custom("SinhalaSangamMN", size: 47))
                                        .kerning(0.64)
                                )
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 2, y: 2)
                            .overlay(
                                Text("Watchlist")
                                    .font(Font.custom("SinhalaSangamMN", size: 47))
                                    .kerning(0.64)
                                    .foregroundColor(.white.opacity(0.4))
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(Rectangle().padding(-1))
                            )
                        
                        
                        Spacer()
                        
                        
                        Button(action: {
                            isMenuVisible.toggle()
                        }) {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .foregroundColor(.blue)
                                .font(.title)
                                .padding()
                        }
                    }
                    .frame(height: 50)
                    .padding(.top, 10)
                    
                    if viewModel.filteredWatchlist.isEmpty {
                        Text("Keine Filme für dieses Genre")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            ForEach(viewModel.filteredWatchlist, id: \.id) { movie in
                                WatchlistRow(movie: movie) {
                                    Task {
                                        await viewModel.removeFromWatchlist(
                                            movie: movie,
                                            userType: appViewModel.userType,
                                            userId: appViewModel.userId ?? ""
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if isMenuVisible {
                ZStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isMenuVisible = false
                        }
                    
                    CustomMenu(
                        isMenuVisible: $isMenuVisible,
                        selectedGenre: $viewModel.selectedGenre,
                        genres: Genre.allCases
                    ) { selectedGenre in
                        viewModel.selectedGenre = selectedGenre
                        viewModel.applyFilter()
                    }
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(8)
                    .padding()
                    .frame(maxWidth: 250)
                    .position(x: UIScreen.main.bounds.width - 120, y: 265)
                }
            }
        }
        .onAppear {
            Task {
                isLoading = true
                await viewModel.fetchWatchlist(for: userType, userId: userId)
                isLoading = false
            }
        }
    }
}


struct WatchlistRow: View {
    let movie: Movie
    let onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            if let posterURL = movie.posterURL {
                AsyncImage(url: posterURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 150)
                .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 150)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
            .padding(.leading, 10)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding()
            }
            .padding(.top, 25)
        }
        .frame(height: 160)
        .padding()
    }
}
