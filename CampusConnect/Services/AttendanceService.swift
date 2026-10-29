import Foundation

extension CampusStore {
    func canCheckIn(_ event: CampusEvent) -> Bool { registrations.contains { $0.memberID == currentUserID && $0.eventID == event.id } && now >= event.start.addingTimeInterval(-3600) }
    func checkIn(_ event: CampusEvent) -> String {
        guard let id = currentUserID, canCheckIn(event) else { return "Check-in unavailable" }
        attendance.append(Attendance(memberID: id, eventID: event.id, checkedInAt: now))
        if let i = members.firstIndex(where: { $0.id == id }) { members[i].points += max(0, event.points - 10) }
        return "Checked in successfully"
    }
    func attendanceRate(_ event: CampusEvent) -> Int { guard event.capacity > 0 else { return 0 }; return Set(attendance.filter { $0.eventID == event.id }.map(\.memberID)).count * 100 / event.capacity }
    func isPresent(_ record: Attendance, for event: CampusEvent) -> Bool { record.checkedInAt <= event.start }

}
