import SwiftUI

struct Recommendation: View {
    @StateObject private var viewModel: RecommendationViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var isLoading = true
    
    init(preferredGenres: [Int], userType: UserType, userId: String) {
        _viewModel = StateObject(
            wrappedValue: RecommendationViewModel(
                preferredGenres: preferredGenres,
                userType: userType,
                userId: userId
            )
        )
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if isLoading {
                LoadingAnimation()
                    .onAppear {
                        Task {
                            try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
                            isLoading = false
                            await viewModel.loadRecommendedMovies()
                        }
                    }
            } else {
                VStack {
                    Text("Empfehlungen")
                        .font(Font.custom("SinhalaSangamMN", size: 50))
                        .kerning(0.64)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.clear)
                        .overlay(
                            LinearGradient(gradient: Gradient(colors: [
                                Color(red: 0.2, green: 0.4, blue: 1.0),
                                Color(red: 0.6, green: 0.8, blue: 1.0)
                            ]), startPoint: .top, endPoint: .bottom)
                            .mask(
                                Text("Empfehlungen")
                                    .font(Font.custom("SinhalaSangamMN", size: 50))
                                    .kerning(0.64)
                            )
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 2, y: 2)
                        .overlay(
                            Text("Empfehlungen")
                                .font(Font.custom("SinhalaSangamMN", size: 50))
                                .kerning(0.64)
                                .foregroundColor(.white.opacity(0.4))
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(Rectangle().padding(-1))
                        )
                    
                    if viewModel.recommendedMovies.isEmpty {
                        Text("Keine Filme verfügbar")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            ForEach(viewModel.recommendedMovies, id: \.id) { movie in
                                MovieRow(
                                    movie: movie,
                                    userType: appViewModel.userType,
                                    userId: appViewModel.userId ?? "",
                                    viewModel: viewModel
                                )
                            }
                        }
                    }
                }
            }
            
            if viewModel.showAddedNotification {
                VStack {
                    Spacer()
                    Text("\(viewModel.addedMovieTitle) wurde zur Watchlist hinzugefügt!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.bottom, 50)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.5), value: viewModel.showAddedNotification)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .onAppear {
            Task {
                await viewModel.loadRecommendedMovies()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ResetRecommendations"))) { _ in
            viewModel.resetRecommendations()
        }
    }
}

struct MovieRow: View {
    let movie: Movie
    let userType: UserType
    let userId: String
    let viewModel: RecommendationViewModel
    
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
                
                Button(action: {
                    Task {
                        do {
                            try await viewModel.addToWatchlist(
                                movie: movie,
                                userType: userType,
                                userId: userId
                            )
                        } catch {
                            print("Fehler beim Hinzufügen zur Watchlist: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Zur Watchlist hinzufügen")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.top, 5)
                }
            }
            .padding(.leading, 10)
            Spacer()
        }
        .frame(height: 160)
        .padding()
    }
}
