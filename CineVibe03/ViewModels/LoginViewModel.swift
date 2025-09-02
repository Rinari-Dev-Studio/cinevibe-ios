import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class LoginViewModel: ObservableObject {
    @Published var loggedInUser: User?
    @Published var familyMembers: [FamilyMember] = []
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated: Bool = false
    
    private let db = Firestore.firestore()
    
    func loginWithEmail(appViewModel: AppViewModel) async {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "bitte das feld ausfüllen"
            return
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let userId = result.user.uid
            
            await loadUserAndFamily(userId: userId, appViewModel: appViewModel)
            errorMessage = nil
            isAuthenticated = true
        } catch {
            errorMessage = "anmeldefehler: \(error.localizedDescription)"
        }
    }
    
    func loadUserAndFamily(userId: String, appViewModel: AppViewModel) async {
        do {
            let userDocument = try await db.collection("users").document(userId).getDocument(as: User.self)
            loggedInUser = userDocument
            appViewModel.logIn(userId: userId)
            let familySnapshot = try await db.collection("users").document(userId).collection("family").getDocuments()
            let loadedFamilyMembers: [FamilyMember] = familySnapshot.documents.compactMap { document in
                try? document.data(as: FamilyMember.self)
            }
            
            await MainActor.run {
                familyMembers = loadedFamilyMembers
            }
            
        } catch {
            errorMessage = "fehler beim laden der daten: \(error.localizedDescription)"
        }
    }
    
    
    func addFamilyMember(name: String, appViewModel: AppViewModel) async {
        guard let userId = appViewModel.userId else {
            errorMessage = "kein eingeloggter benutzer"
            return
        }
        
        let familyRef = db.collection("users").document(userId).collection("family")
        
        do {
            let newMemberData: [String: Any] = [
                "name": name
            ]
            let documentRef = try await familyRef.addDocument(data: newMemberData)
            let addedMember = FamilyMember(
                id: documentRef.documentID,
                name: name
            )
            
            await MainActor.run {
                familyMembers.append(addedMember)
            }
            
        } catch {
            errorMessage = "fehler hinzufügen family...\(error.localizedDescription)"
        }
    }
}
