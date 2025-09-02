import SwiftUI

struct UserSelection: View {
    @StateObject var viewModel = UserSelectionViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State private var selectedUser: User? = nil
    @State private var showOptions = false
    @State private var navigateToRating = false
    @State private var navigateToWatchlist = false
    @State private var showAddFamilyMemberDialog = false
    @State private var newMemberName = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("Benutzer auswählen")
                    .font(Font.custom("SinhalaSangamMN", size: 37)) 
                    .kerning(0.64)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.clear)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [
                            Color(red: 0.2, green: 0.4, blue: 1.0),
                            Color(red: 0.6, green: 0.8, blue: 1.0)
                        ]), startPoint: .top, endPoint: .bottom)
                        .mask(
                            Text("Benutzer auswählen")
                                .font(Font.custom("SinhalaSangamMN", size: 37))
                                .kerning(0.64)
                        )
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 2, y: 2)
                    .overlay(
                        Text("Benutzer auswählen")
                            .font(Font.custom("SinhalaSangamMN", size: 37))
                            .kerning(0.64)
                            .foregroundColor(.white.opacity(0.4))
                            .blur(radius: 4)
                            .offset(x: -2, y: -2)
                            .mask(Rectangle().padding(-1))
                    )

                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding()
                }
                
                LazyVGrid(columns: columns, spacing: 20) {
                    if let loggedInUser = viewModel.loggedInUser {
                        userCircle(user: loggedInUser, isLoggedIn: true)
                    }
                    
                    ForEach(viewModel.familyMembers, id: \.id) { member in
                        let user = User(
                            id: member.id,
                            firstname: member.name,
                            lastname: "",
                            birthdate: Date(),
                            email: nil,
                            role: .familyMember
                        )
                        userCircle(user: user, isLoggedIn: false)
                    }
                    
                    Button(action: {
                        showAddFamilyMemberDialog = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.4))
                                .frame(width: 100, height: 100)
                                .blur(radius: 10)
                            
                            Circle()
                                .fill(Color.black)
                                .frame(width: 80, height: 80)
                                .contentShape(Circle())
                            
                            Text("+")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
            }
            .disabled(showOptions)
            
            if showOptions {
                VStack(spacing: 20) {
                    Button(action: {
                        navigateToRating = true
                        withAnimation { showOptions = false }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.cyan.opacity(0.3))
                                .frame(width: 180, height: 50)
                                .blur(radius: 10)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(width: 160, height: 40)
                            
                            Text("Rating")
                                .font(.headline)
                                .foregroundColor(.cyan)
                        }
                    }
                    
                    Button(action: {
                        appViewModel.isNavigatedFromUserSelection = true
                        navigateToWatchlist = true
                        withAnimation { showOptions = false }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.cyan.opacity(0.3))
                                .frame(width: 180, height: 50)
                                .blur(radius: 10)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(width: 160, height: 40)
                            
                            Text("Watchlist")
                                .font(.headline)
                                .foregroundColor(.cyan)
                        }
                    }
                    
                    Button(action: {
                        withAnimation { showOptions = false }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.red.opacity(0.3))
                                .frame(width: 180, height: 50)
                                .blur(radius: 10)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(width: 160, height: 40)
                            
                            Text("Abbrechen")
                                .font(.headline)
                                .foregroundColor(.red.opacity(0.7))
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.9))
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 40)
                .transition(.move(edge: .bottom))
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 200)
            }
        }
        .alert("Familienmitglied hinzufügen", isPresented: $showAddFamilyMemberDialog) {
            TextField("Name", text: $newMemberName)
            Button("Abbrechen", role: .cancel) {}
            Button("Hinzufügen") {
                Task {
                    await viewModel.addFamilyMember(
                        name: newMemberName,
                        appViewModel: appViewModel
                    )
                    newMemberName = ""
                    if let userId = appViewModel.userId {
                        await viewModel.loadUserAndFamily(userId: userId, appViewModel: appViewModel)
                    }
                }
            }
        } message: {
            Text("Bitte geben Sie den Namen des neuen Familienmitglieds ein.")
        }
        .onAppear {
            Task {
                if let userId = appViewModel.userId {
                    await viewModel.loadUserAndFamily(userId: userId, appViewModel: appViewModel)
                } else {
                    print("Fehler: Keine Benutzer-ID gefunden")
                }
            }
        }
        .fullScreenCover(isPresented: $navigateToRating) {
            if let selectedUser = selectedUser {
                Rating(
                    userType: selectedUser.id == appViewModel.userId
                    ? .mainUser
                    : .familyMember(familyMemberId: selectedUser.id ?? ""),
                    userId: appViewModel.userId ?? ""
                )
            }
        }
        .fullScreenCover(isPresented: $navigateToWatchlist) {
            if let selectedUser = selectedUser {
                Watchlist(
                    userType: selectedUser.id == appViewModel.userId
                    ? .mainUser
                    : .familyMember(familyMemberId: selectedUser.id ?? ""),
                    userId: appViewModel.userId ?? ""
                )
            }
        }
    }
    
    private func userCircle(user: User, isLoggedIn: Bool) -> some View {
        ZStack {
            Circle()
                .fill(Color.cyan.opacity(0.3))
                .frame(width: 100, height: 100)
                .blur(radius: 10)
            
            Circle()
                .fill(Color.black)
                .frame(width: 80, height: 80)
                .contentShape(Circle())
                .onTapGesture {
                    selectedUser = user
                    
                    if user.id == appViewModel.userId {
                        appViewModel.logIn(userId: user.id ?? "")
                    } else {
                        appViewModel.logInAsFamilyMember(userId: appViewModel.userId ?? "", familyMemberId: user.id ?? "")
                    }
                    
                    withAnimation {
                        showOptions = true
                    }
                }
            Text(user.firstname)
                .font(.system(size: fontSize(for: user.firstname)))
                .foregroundColor(.cyan)
                .multilineTextAlignment(.center)
        }
    }
    
    private func fontSize(for name: String) -> CGFloat {
        return name.count > 6 ? 10 : 14
    }
}
