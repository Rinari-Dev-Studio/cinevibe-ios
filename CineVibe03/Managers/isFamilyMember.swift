import Foundation

func isFamilyMember(userId: String, familyMemberId: String?) -> Bool {
    return familyMemberId != nil && userId != familyMemberId
}
