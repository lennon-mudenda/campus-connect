import Foundation

struct CampusSnapshot {
    var members: [Member]
    var events: [CampusEvent]
    var registrations: [Registration]
    var attendance: [Attendance]
}

protocol CampusRepository {
    func load(referenceDate: Date) -> CampusSnapshot
}

struct MockCampusRepository: CampusRepository {
    func load(referenceDate now: Date) -> CampusSnapshot {
        let facilitatorIDs = (0..<3).map { UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", 101+$0))! }
        let members = (0..<20).map { i in Member(id: UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", 1001+i))!, name: ["Tariro", "Tawanda", "Rudo", "Nyasha", "Farai", "Chipo", "Simba", "Kudzai", "Tinashe", "Anesu", "Tatenda", "Munashe", "Tafadzwa", "Ruvarashe", "Tanaka", "Takunda", "Makanaka", "Rutendo", "Tadiwa", "Blessing"][i], email: "student\(i+1)@mcri.edu", role: .student, points: (i*37)%240, cohort: "Cohort \(1+i%3)") } + (0..<3).map { i in Member(id: facilitatorIDs[i], name: ["Alex Moyo", "Sam Dube", "Pat Ncube"][i], email: "facilitator\(i+1)@mcri.edu", role: .facilitator, points: 0, cohort: "Staff") }
        let titles = ["Swift Fundamentals", "Build Your First App", "Supabase Essentials", "Git and GitHub", "Team Coding Sprint", "Career Mentorship", "Algorithms Lab", "UI Design Workshop", "Hackathon Kickoff", "Technical Interview Prep", "Database Design", "Debugging Clinic", "Community Showcase", "Testing Swift Apps", "Portfolio Review", "API Integration", "Accessibility Lab", "Advanced SwiftUI", "Code Review Session", "Mobile Architecture", "Communication Skills", "Product Design", "Problem Solving", "Demo Day", "Leadership Workshop"]
        let events = titles.enumerated().map { i, title in
            let start = Calendar.current.date(byAdding: .day, value: i-8, to: Calendar.current.startOfDay(for: now))!.addingTimeInterval(14*3600)
            return CampusEvent(id: UUID(uuidString: String(format: "10000000-0000-0000-0000-%012d", i+1))!, title: title, details: "Join fellow MCRI learners for a hands-on session exploring \(title.lowercased()). Bring your ideas and collaborate.", category: EventCategory.allCases[i%5], start: start, deadline: start.addingTimeInterval(-3600), location: ["Innovation Lab", "Main Hall", "Room 204", "Online"][i%4], capacity: 8+(i%4)*5, points: 20+(i%4)*10, facilitatorID: facilitatorIDs[i%3], cancelled: i==19)
        }
        let registrations = (0..<50).map { i in Registration(id: UUID(uuidString: String(format: "20000000-0000-0000-0000-%012d", i+1))!, memberID: members[i%20].id, eventID: events[(i*7)%25].id, status: i%11 == 0 ? .cancelled : .active) }
        var attendance = (0..<20).map { i in Attendance(id: UUID(uuidString: String(format: "30000000-0000-0000-0000-%012d", i+1))!, memberID: registrations[i].memberID, eventID: registrations[i].eventID, checkedInAt: events[(i*7)%25].start.addingTimeInterval(Double(i%3)*600)) }
        attendance[18].checkedInAt = Calendar.current.date(byAdding: .year, value: -1, to: attendance[18].checkedInAt)!
        attendance[19].checkedInAt = Calendar.current.startOfDay(for: now).addingTimeInterval(1800)
        return CampusSnapshot(members: members, events: events, registrations: registrations, attendance: attendance)
    }
}
