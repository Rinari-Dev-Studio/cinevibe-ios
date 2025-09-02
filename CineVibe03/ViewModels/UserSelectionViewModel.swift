import FirebaseFirestore

@MainActor
class UserSelectionViewModel: ObservableObject {
    @Published var familyMembers: [FamilyMember] = []
    @Published var errorMessage: String? = nil
    @Published var loggedInUser: User? = nil
    
    
    func loadUserAndFamily(userId: String, appViewModel: AppViewModel) async {
        let db = Firestore.firestore()
        
        do {
            
            let userDocument = try await db.collection("users").document(userId).getDocument(as: User.self)
            self.loggedInUser = userDocument
        
            let familySnapshot = try await db.collection("users").document(userId).collection("family").getDocuments()
            self.familyMembers = familySnapshot.documents.compactMap { try? $0.data(as: FamilyMember.self) }
            
        } catch {
            self.errorMessage = "fehler beim laden der daten \(error.localizedDescription)"
        }
    }
    
    
    
    
    func addFamilyMember(name: String, appViewModel: AppViewModel) async {
        guard let userId = appViewModel.userId else {
            errorMessage = "BenutzerID nicht verfügbar."
            return
        }
        
        let db = Firestore.firestore()
        let familyRef = db.collection("users").document(userId).collection("family")
        let newMember = FamilyMember(id: UUID().uuidString, name: name)
        
        do {
            try await familyRef.document(newMember.id!).setData([
                "id": newMember.id!,
                "name": newMember.name
            ])
            
            self.familyMembers.append(newMember)
            print("familienmitglied \(name) hinzugefügt.")
        } catch {
            self.errorMessage = "fehler beim hinzufügen des FM \(error.localizedDescription)"
        }
    }
}
