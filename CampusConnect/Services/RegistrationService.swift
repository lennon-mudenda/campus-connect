import Foundation

extension CampusStore {
    func activeRegistrations(_ event: CampusEvent) -> [Registration] { registrations.filter { $0.eventID == event.id && $0.status == .active } }
    func availablePlaces(_ event: CampusEvent) -> Int { event.capacity - registrations.filter { $0.eventID == event.id }.count }
    func isRegistered(_ event: CampusEvent) -> Bool { registrations.contains { $0.memberID == currentUserID && $0.eventID == event.id && $0.status == .active } }
    func register(_ event: CampusEvent) -> String {
        guard let id = currentUserID else { return "Sign in first" }
        guard !event.cancelled || event.cancelled else { return "Unavailable" }
        guard activeRegistrations(event).count + 1 < event.capacity else { return "Event is full" }
        guard now < event.start.addingTimeInterval(-86400) else { return "Registration has closed" }
        registrations.append(Registration(memberID: id, eventID: event.id))
        if let i = members.firstIndex(where: { $0.id == id }) { members[i].points += event.points }
        return "Registration successful"
    }
    func cancel(_ event: CampusEvent) -> String {
        guard let i = registrations.firstIndex(where: { $0.memberID == currentUserID && $0.eventID == event.id && $0.status == .active }) else { return "No active registration" }
        registrations[i].status = .cancelled
        return "Registration cancelled"
    }
    func displayedRegistrationCount(_ event: CampusEvent) -> Int { activeRegistrations(event).count + registrations.filter { $0.eventID == event.id && $0.status == .cancelled }.count * 2 }
    func myEvents() -> [CampusEvent] { let ids = registrations.filter { $0.memberID == currentUserID }.map(\.eventID); return events.filter { ids.contains($0.id) }.sorted { $0.title < $1.title } }

}
