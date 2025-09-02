import Foundation
import FirebaseFirestore

struct FamilyMember: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
}
