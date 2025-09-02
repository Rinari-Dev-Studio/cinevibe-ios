import Foundation
import SwiftUI

enum UserType {
    case mainUser
    case familyMember(familyMemberId: String)
}

class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userId: String?
    @Published var userType: UserType = .mainUser
    @Published var isNavigatedFromUserSelection: Bool = false
    @Published var loggedInUser: User?
    @Published var familyMembers: [FamilyMember] = []
    
    func logIn(userId: String) {
        self.userId = userId
        self.userType = .mainUser
        self.isLoggedIn = true
    }
    
    func logInAsFamilyMember(userId: String, familyMemberId: String) {
        self.userId = userId
        self.userType = .familyMember(familyMemberId: familyMemberId)
        self.isLoggedIn = true
    }
    
    func resetAppState() {
        self.isLoggedIn = false
        self.userId = nil
        self.userType = .mainUser
        self.isNavigatedFromUserSelection = false
    }
    
    func logOut() {
        resetAppState()
        print("Benutzer wurde ausgeloggt.")
    }
    
    func switchUser() {
        resetAppState()
        NotificationCenter.default.post(name: Notification.Name("SwitchUser"), object: nil)
        print("Benutzer wechseln initiiert.")
    }
    
    var currentUserName: String {
        switch userType {
        case .mainUser:
            if let user = loggedInUser {
                return user.firstname
            } else {
                return "Unbekannter Benutzer"
            }
        case .familyMember(let familyMemberId):
            if let familyMember = familyMembers.first(where: { $0.id == familyMemberId }) {
                return familyMember.name
            } else {
                return "Unbekanntes Familienmitglied"
            }
        }
    }
    
}
