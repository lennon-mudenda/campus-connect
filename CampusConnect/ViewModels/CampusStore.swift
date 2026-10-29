import Foundation
import SwiftUI

@MainActor final class CampusStore: ObservableObject {
    @Published var members: [Member] = []
    @Published var events: [CampusEvent] = []
    @Published var registrations: [Registration] = []
    @Published var attendance: [Attendance] = []
    @Published var currentUserID: UUID?
    @Published var search = ""
    @Published var selectedCategory: EventCategory?
    @Published var sortSoonest = true { didSet { preferences?.set(sortSoonest, forKey: "sortSoonest") } }
    @Published var dashboardCount = 0
    @Published var cachedResults: [CampusEvent] = []
    @Published var showFacilitatorTab = false
    @Published var now: Date
    let repository: any CampusRepository
    var currentUser: Member? { members.first { $0.id == currentUserID } }
    let preferences: UserDefaults?
    init(repository: any CampusRepository = MockCampusRepository(), now: Date = DemoClock.referenceDate, preferences: UserDefaults? = .standard) {
        self.repository = repository
        self.now = now
        self.preferences = preferences
        reset()
        if let saved = preferences?.object(forKey: "sortSoonest") as? Bool { sortSoonest = saved }
    }
    func reset() {
        let snapshot = repository.load(referenceDate: DemoClock.referenceDate)
        members = snapshot.members
        events = snapshot.events
        registrations = snapshot.registrations
        attendance = snapshot.attendance
        currentUserID = members.first?.id
        showFacilitatorTab = false
        search = ""
        selectedCategory = nil
        cachedResults = events
        refreshDashboard()
    }
}
