import Foundation
import FirebaseFirestore
import FirebaseAuth

class RegistrationViewModel: ObservableObject {
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var birthdate: Date = Date()
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isRegistered: Bool = false
    @Published var userId: String?
    
    private let db = Firestore.firestore()
    
    var isFormInvalid: Bool {
        firstname.isEmpty || lastname.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword
    }
    
    private func calculateAge(from birthdate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: birthdate, to: Date())
        return components.year ?? 0
    }
    
    func registerUser(appViewModel: AppViewModel) async {
        guard !isFormInvalid else {
            errorMessage = "Bitte fülle alle Felder aus und stelle sicher, dass die Passwörter übereinstimmen."
            return
        }
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let userId = authResult.user.uid
            
            let userDocRef = db.collection("users").document(userId)
            
            let newUser = User(
                id: userId,
                firstname: firstname,
                lastname: lastname,
                birthdate: birthdate,
                email: email,
                role: .admin
            )
            
            try await userDocRef.setData([
                "firstname": newUser.firstname,
                "lastname": newUser.lastname,
                "birthdate": Timestamp(date: newUser.birthdate),
                "email": newUser.email ?? "",
                "role": newUser.role.rawValue,
                "age": newUser.age
            ])
            
            await MainActor.run {
                appViewModel.logIn(userId: userId)
                self.userId = userId
                self.isRegistered = true
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Registrierungsfehler: \(error.localizedDescription)"
            }
        }
    }
}
