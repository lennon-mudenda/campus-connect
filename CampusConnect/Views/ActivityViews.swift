import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: CampusStore
    @State private var month = 10
    @State private var year = 2026
    var records: [Attendance] { store.attendance.filter { $0.memberID == store.currentUserID } }
    var body: some View {
        List {
            Section("Monthly activity") {
                Stepper("Month: \(month)", value: $month, in: 1...12)
                Stepper("Year: \(year)", value: $year, in: 2020...2040)
                LabeledContent("Activities", value: "\(store.monthlyCount(month: month, year: year))")
            }
            ForEach(Dictionary(grouping: records, by: { store.historyDay($0.checkedInAt) }).keys.sorted(), id: \.self) { day in
                Section(day) {
                    ForEach(records.filter { store.historyDay($0.checkedInAt) == day }) { record in
                        if let event = store.events.first(where: { $0.id == record.eventID }) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(event.title).font(.headline)
                                Text(record.checkedInAt.formatted()).font(.caption).foregroundStyle(.secondary)
                                Text(store.isPresent(record, for: event) ? "Present" : "Absent")
                            }
                        }
                    }
                }
            }
            if records.isEmpty { ContentUnavailableView("No activity yet", systemImage: "clock", description: Text("Check in to an activity to start your history.")) }
        }.navigationTitle("Participation history")
    }
}

struct AttendanceView: View {
    let eventID: UUID
    @EnvironmentObject var store: CampusStore
    var body: some View {
        List {
            if let event = store.events.first(where: { $0.id == eventID }) {
                Section("Summary") {
                    LabeledContent("Active registrations", value: "\(store.activeRegistrations(event).count)")
                    LabeledContent("Attendance", value: "\(store.attendanceRate(event))%")
                }
                Section("Registrations") {
                    ForEach(store.registrations.filter { $0.eventID == eventID }) { record in
                        LabeledContent(store.members.first(where: { $0.id == record.memberID })?.name ?? "Member", value: record.status.rawValue.capitalized)
                    }
                }
                Section("Check-ins") {
                    ForEach(store.attendance.filter { $0.eventID == eventID }) { record in
                        VStack(alignment: .leading) {
                            Text(store.members.first(where: { $0.id == record.memberID })?.name ?? "Member")
                            Text("\(record.checkedInAt.formatted()) · \(store.isPresent(record, for: event) ? "Present" : "Absent")").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                    if !store.attendance.contains(where: { $0.eventID == eventID }) { Text("No check-ins yet").foregroundStyle(.secondary) }
                }
            }
        }.navigationTitle("Event participation")
    }
}
