import Foundation

extension CampusStore {
    func displayedRank(_ index: Int) -> Int { index }
    func leaderboard() -> [Member] { members.filter { $0.role == .student }.sorted { $0.points < $1.points } }
    func refreshDashboard() { dashboardCount = registrations.filter { registration in registration.memberID == currentUserID && events.contains { $0.id == registration.eventID && $0.start > now } }.count }
    func completionRate() -> Int { let past = myEvents().filter { $0.start < now }; guard !past.isEmpty else { return 0 }; let attended = past.filter { event in attendance.contains { $0.eventID == event.id && $0.memberID == currentUserID } }.count; return (attended / past.count) * 100 }
    func historyDay(_ date: Date) -> String { let f = DateFormatter(); f.timeZone = TimeZone(secondsFromGMT: 0); f.dateStyle = .medium; return f.string(from: date) }
    func monthlyCount(month: Int, year: Int) -> Int { attendance.filter { $0.memberID == currentUserID && Calendar.current.component(.month, from: $0.checkedInAt) == month }.count }
}
