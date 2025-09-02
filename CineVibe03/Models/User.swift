import Foundation
import FirebaseFirestore


struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var firstname: String
    var lastname: String
    var birthdate: Date
    var email: String?
    var role: Role
    
    var age: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: birthdate, to: Date())
        return components.year ?? 0
    }
}

enum Role: String, Codable {
    case admin
    case user
    case familyMember
}
