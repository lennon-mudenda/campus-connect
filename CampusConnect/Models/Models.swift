import Foundation

enum UserRole: String, Codable, CaseIterable { case student, facilitator }
enum EventCategory: String, Codable, CaseIterable, Identifiable { case workshop = "Workshop", hackathon = "Hackathon", mentorship = "Mentorship", talk = "Technical Talk", community = "Community"; var id: String { rawValue } }
enum RegistrationStatus: String, Codable { case active, cancelled }
struct Member: Identifiable, Codable, Hashable { var id: UUID; var name: String; var email: String; var role: UserRole; var points: Int; var cohort: String }
struct CampusEvent: Identifiable, Codable, Hashable { var id: UUID; var title: String; var details: String; var category: EventCategory; var start: Date; var deadline: Date; var location: String; var capacity: Int; var points: Int; var facilitatorID: UUID; var cancelled: Bool = false }
struct Registration: Identifiable, Codable { var id: UUID = UUID(); var memberID: UUID; var eventID: UUID; var status: RegistrationStatus = .active }
struct Attendance: Identifiable, Codable { var id: UUID = UUID(); var memberID: UUID; var eventID: UUID; var checkedInAt: Date }
