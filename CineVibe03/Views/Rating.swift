import SwiftUI

struct Rating: View {
    @StateObject private var viewModel = RatingViewModel()
    let userType: UserType
    let userId: String
    
    @State private var showSwipeHint = true
    @State private var highlightDislike = false
    @State private var highlightLike = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if viewModel.isLoading {
                LoadingAnimation()
            } else if viewModel.showRecommendations {
                RecommendationContainer(
                    preferredGenres: viewModel.preferredGenres,
                    userType: userType,
                    userId: userId
                )
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                VStack {
                    if showSwipeHint {
                        HStack(spacing: 40) {
                            VStack {
                                Image(systemName: "arrow.left")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(highlightDislike ? .red : .gray)
                                    .opacity(highlightDislike ? 1 : 0.5)
                                    .animation(.easeInOut(duration: 0.5), value: highlightDislike)
                                Text("Dislike")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Text("Swipe")
                                .font(.largeTitle)
                                .font(.headline.weight(.bold))
                                .foregroundColor(.white)
                            
                            VStack {
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(highlightLike ? .green : .gray)
                                    .opacity(highlightLike ? 1 : 0.5)
                                    .animation(.easeInOut(duration: 0.5), value: highlightLike)
                                Text("Like")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 20)
                        .offset(x: -10, y: 30)
                        
                        .onAppear {
                            startBlinkingHints()
                        }
                    }
                    
                    if let currentMovie = viewModel.currentMovie {
                        movieCard(movie: currentMovie)
                    } else {
                        Text("Keine Filme verfügbar")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadMovies(random: true)
            }
        }
    }
    
    private func startBlinkingHints() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            highlightDislike = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                highlightDislike = false
                highlightLike = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    highlightLike = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            showSwipeHint = false
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func movieCard(movie: Movie) -> some View {
        VStack {
            if let posterURL = movie.posterURL {
                AsyncImage(url: posterURL) { phase in
                    switch phase {
                    case .empty:
                        Color.clear
                            .frame(width: 350, height: 500)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 500)
                            .opacity(0.9)
                            .cornerRadius(12)
                    case .failure:
                        Text("Bild konnte nicht geladen werden")
                            .frame(width: 350, height: 500)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(12)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Text("Kein Bild verfügbar")
                    .foregroundColor(.gray)
                    .frame(width: 350, height: 500)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(12)
            }
            
            Text(movie.title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 8)
            
            ScrollView {
                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(height: 100)
        }
        .padding()
        .offset(x: viewModel.offset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    viewModel.updateGestureOffset(value.translation.width)
                }
                .onEnded { value in
                    viewModel.handleSwipeGesture(value.translation.width)
                }
        )
        .animation(.spring(), value: viewModel.offset)
    }
}
