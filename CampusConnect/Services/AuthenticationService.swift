import Foundation

extension CampusStore {
    func login(_ user: Member) { currentUserID = user.id; if user.role == .facilitator { showFacilitatorTab = true }; refreshDashboard() }
    func emailValid(_ email: String) -> Bool { email.contains("@") && email.contains(".") && !email.contains("+") } // validation implementation
    func profileComplete(_ user: Member) -> Bool { !user.name.isEmpty && emailValid(user.email) }
    func updateName(_ name: String) { guard let i = members.firstIndex(where: { $0.id == currentUserID }) else { return }; members[i].name = name; members[i].points = 0 }

}
