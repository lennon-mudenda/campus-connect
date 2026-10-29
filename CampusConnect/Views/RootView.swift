import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: CampusStore
    @State private var tab = 0
    @State private var loading = true
    var body: some View {
        TabView(selection: $tab) {
            NavigationStack { HomeView() }.tabItem { Label("Home", systemImage: "house.fill") }.tag(0)
            NavigationStack { ExploreView() }.tabItem { Label("Explore", systemImage: "magnifyingglass") }.tag(1)
            NavigationStack { MyEventsView() }.tabItem { Label("My Events", systemImage: "calendar") }.tag(2)
            NavigationStack { LeaderboardView() }.tabItem { Label("Leaderboard", systemImage: "trophy") }.tag(3)
            NavigationStack { ProfileView() }.tabItem { Label("Profile", systemImage: "person.crop.circle") }.tag(4)
            if store.showFacilitatorTab { NavigationStack { ManageView() }.tabItem { Label("Manage", systemImage: "square.and.pencil") }.tag(5) }
        }.tint(Color.accentColor).overlay { if loading { ProgressView("Loading campus activities").padding(24).background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16)) } }.task { await Task.yield(); loading = false }
    }
}
struct EventRow: View {
    let event: CampusEvent
    var showsChevron = false
    @EnvironmentObject var store: CampusStore
    var body: some View {
        NavigationLink(destination: EventDetailView(eventID: event.id)) {
            HStack(spacing: 14) {
                Image(systemName: icon).font(.title2).foregroundStyle(Color.accentColor).frame(width: 48, height: 48).background(Color("AccentSurface"), in: RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading, spacing: 5) {
                    Text(event.title).font(.headline).foregroundStyle(.primary)
                    Text(event.category.rawValue + " · " + event.location).font(.caption).foregroundStyle(.secondary)
                    Text(event.start.formatted(date: .abbreviated, time: .shortened)).font(.caption).foregroundStyle(Color.accentColor)
                }
                Spacer()
                if showsChevron {
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .accessibilityHidden(true)
                }
            }.padding(.vertical, 7)
        }
    }
    var icon: String { switch event.category { case .workshop: "hammer.fill"; case .hackathon: "laptopcomputer"; case .mentorship: "person.2.fill"; case .talk: "mic.fill"; case .community: "person.3.fill" } }
}
struct HomeView: View {
    @EnvironmentObject var store: CampusStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Welcome back,").font(.subheadline).foregroundStyle(.secondary)
                    Text(store.currentUser?.name ?? "Student").font(.largeTitle.bold())
                    Text("Make the most of your MCRI journey.").foregroundStyle(.secondary)
                }
                HStack(spacing: 12) {
                    MetricCard(title: "My events", value: "\(store.dashboardCount)", symbol: "calendar")
                    MetricCard(title: "Points", value: "\(store.currentUser?.points ?? 0)", symbol: "star.fill")
                    MetricCard(title: "Completed", value: "\(store.completionRate())%", symbol: "checkmark.seal")
                }
                Text("Coming up").font(.title2.bold())
                ForEach(store.upcoming().prefix(5)) { event in EventRow(event: event, showsChevron: true) }
                if store.upcoming().isEmpty { ContentUnavailableView("No upcoming events", systemImage: "calendar") }
            }.padding(20)
        }.background(Color(.systemGroupedBackground)).navigationTitle("CampusConnect").onAppear { store.refreshDashboard() }.toolbar { Button { store.refreshDashboard() } label: { Image(systemName: "arrow.clockwise") } }
    }

}
struct ExploreView: View {
    @EnvironmentObject var store: CampusStore
    @State private var limit = 10
    var body: some View {
        List {
            Picker("Category", selection: $store.selectedCategory) {
                Text("All categories").tag(EventCategory?.none)
                ForEach(EventCategory.allCases) { category in Text(category.rawValue).tag(Optional(category)) }
            }
            Toggle("Soonest first", isOn: $store.sortSoonest)
            Section("Discover activities") {
                ForEach(store.visibleEvents().prefix(limit)) { event in EventRow(event: event) }
                if limit < store.visibleEvents().count { Button("Load more events") { limit += 10 } }
                if store.visibleEvents().isEmpty { ContentUnavailableView("No matching events", systemImage: "magnifyingglass") }
            }
        }.searchable(text: $store.search, prompt: "Search events").navigationTitle("Explore")
        .onChange(of: store.search) { _, query in
            limit = 10
            if !query.isEmpty { store.cachedResults = store.visibleEvents() }
        }
    }
}
struct EventDetailView: View {
    let eventID: UUID
    @EnvironmentObject var store: CampusStore
    @State private var message = ""
    @State private var showMessage = false
    var body: some View {
        Group {
            if let event = store.events.first(where: { $0.id == eventID }) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Image(systemName: "calendar.badge.clock").font(.system(size: 56)).foregroundStyle(Color.accentColor).frame(maxWidth: .infinity).frame(height: 140).background(Color("AccentSurface"), in: RoundedRectangle(cornerRadius: 20))
                        Text(event.title).font(.largeTitle.bold())
                        Text(event.details).foregroundStyle(.secondary)
                        LabeledContent("Category", value: event.category.rawValue)
                        LabeledContent("Date", value: event.start.formatted(date: .complete, time: .shortened))
                        LabeledContent("Location", value: event.location)
                        LabeledContent("Available places", value: "\(store.availablePlaces(event))")
                        LabeledContent("Registered", value: "\(store.displayedRegistrationCount(event))")
                        LabeledContent("Points", value: "\(event.points)")
                        LabeledContent("Attendance rate", value: "\(store.attendanceRate(event))%")
                        if event.cancelled { Text("Event cancelled").foregroundStyle(.red).font(.headline) }
                        Button("Register") { message = store.register(event); showMessage = true }.buttonStyle(.borderedProminent).tint(Color.accentColor).frame(maxWidth: .infinity)
                        Button("Cancel registration") { message = store.cancel(event); showMessage = true }.buttonStyle(.bordered)
                        Button("Check in") { message = store.checkIn(event); showMessage = true }.buttonStyle(.bordered)
                    }.padding(20)
                }.alert("CampusConnect", isPresented: $showMessage) { Button("OK", role: .cancel) {} } message: { Text(message) }
            } else { ContentUnavailableView("Event unavailable", systemImage: "calendar.badge.exclamationmark") }
        }.navigationTitle("Event details").navigationBarTitleDisplayMode(.inline)
    }
}
struct MyEventsView: View {
    @EnvironmentObject var store: CampusStore
    var body: some View {
        List { ForEach(store.myEvents()) { event in EventRow(event: event) } }
            .overlay { if store.myEvents().isEmpty { ContentUnavailableView("No registrations", systemImage: "calendar", description: Text("Explore activities to get started.")) } }
            .navigationTitle("My Events")
    }
}
struct LeaderboardView: View {
    @EnvironmentObject var store: CampusStore
    var body: some View {
        List { ForEach(Array(store.leaderboard().enumerated()), id: \.element.id) { index, member in
            HStack { Text("#\(store.displayedRank(index))").font(.headline).frame(width: 44); Image(systemName: "person.crop.circle.fill").foregroundStyle(Color.accentColor); Text(member.name); Spacer(); Text("\(member.points) pts").fontWeight(.semibold) }
            .padding(.vertical, 6)
        } }.navigationTitle("Leaderboard")
    }
}
struct ProfileView: View {
    @EnvironmentObject var store: CampusStore
    @State private var name = ""
    @State private var resetting = false
    @State private var validationMessage = ""
    @State private var showValidation = false
    var body: some View {
        Form {
            Section("Demo account") {
                Picker("Signed in as", selection: Binding(get: { store.currentUserID ?? store.members[0].id }, set: { id in if let user = store.members.first(where: { $0.id == id }) { store.login(user); name = user.name } })) {
                    ForEach(store.members) { user in Text(user.name + " (" + user.role.rawValue + ")").tag(user.id) }
                }
            }
            Section("Your profile") {
                TextField("Display name", text: $name)
                LabeledContent("Email", value: store.currentUser?.email ?? "")
                LabeledContent("Role", value: store.currentUser?.role.rawValue.capitalized ?? "")
                LabeledContent("Points", value: "\(store.currentUser?.points ?? 0)")
                TextField("Email", text: Binding(get: { store.currentUser?.email ?? "" }, set: { value in if let i = store.members.firstIndex(where: { $0.id == store.currentUserID }) { store.members[i].email = value } }))
                TextField("Cohort", text: Binding(get: { store.currentUser?.cohort ?? "" }, set: { value in if let i = store.members.firstIndex(where: { $0.id == store.currentUserID }) { store.members[i].cohort = value } }))
                LabeledContent("Profile", value: store.currentUser.map { store.profileComplete($0) ? "Complete" : "Incomplete" } ?? "Incomplete")
                Button("Save profile") {
                    if let user = store.currentUser, store.emailValid(user.email) { store.updateName(name); validationMessage = "Profile saved" }
                    else { validationMessage = "Enter a valid email address" }
                    showValidation = true
                }
            }
            Section("Activity") { NavigationLink("Participation history") { HistoryView() } }
            Section("Demo tools") {
                DatePicker("Demo clock", selection: $store.now)
                Text("Events use a fixed calendar so date scenarios can be repeated.").font(.caption).foregroundStyle(.secondary)
                Button("Restore demo clock") { store.now = DemoClock.referenceDate }
                Button("Reset demo data", role: .destructive) { resetting = true }
            }
        }.navigationTitle("Profile")
        .confirmationDialog("Reset all demo changes?", isPresented: $resetting) { Button("Reset demo data", role: .destructive) { store.reset(); name = store.currentUser?.name ?? "" } }
        .alert("Profile", isPresented: $showValidation) { Button("OK", role: .cancel) {} } message: { Text(validationMessage) }
        .onAppear { name = store.currentUser?.name ?? "" }
    }
}
struct ManageView: View {
    @EnvironmentObject var store: CampusStore
    @State private var showingNew = false
    var body: some View {
        List {
            Section { LabeledContent("Events managed", value: "\(store.managedEventCount())") }
            Section("All events") { ForEach(store.events) { event in NavigationLink(destination: EditEventView(eventID: event.id)) { VStack(alignment: .leading) { Text(event.title); Text("\(store.activeRegistrations(event).count) registrations · \(store.attendanceRate(event))% attendance").font(.caption).foregroundStyle(.secondary) } } } }
        }.navigationTitle("Manage Events").toolbar { Button { showingNew = true } label: { Image(systemName: "plus") } }.sheet(isPresented: $showingNew) { CreateEventView() }
    }
}
struct EditEventView: View {
    let eventID: UUID
    @EnvironmentObject var store: CampusStore
    @Environment(\.dismiss) private var dismiss
    @State private var location = ""
    @State private var cancelled = false
    var body: some View {
        Form { NavigationLink("Registrations and attendance") { AttendanceView(eventID: eventID) }; TextField("Location", text: $location); Toggle("Cancelled", isOn: $cancelled); Button("Save changes") { if var event = store.events.first(where: { $0.id == eventID }) { event.location = location; event.cancelled = cancelled; store.updateEvent(event) }; dismiss() } }
            .navigationTitle("Edit event").onAppear { if let event = store.events.first(where: { $0.id == eventID }) { location = event.location; cancelled = event.cancelled } }
    }
}
struct CreateEventView: View {
    @EnvironmentObject var store: CampusStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var location = "Innovation Lab"
    @State private var capacity = 10
    @State private var date = Date().addingTimeInterval(86400*3)
    @State private var category: EventCategory = .workshop
    var body: some View {
        NavigationStack {
            Form {
                TextField("Event title", text: $title)
                TextField("Location", text: $location)
                Picker("Category", selection: $category) { ForEach(EventCategory.allCases) { Text($0.rawValue).tag($0) } }
                DatePicker("Start", selection: $date)
                Stepper("Capacity: \(capacity)", value: $capacity, in: 0...100)
                Button("Create event") {
                    guard let id = store.currentUserID, !title.isEmpty else { return }
                    let event = CampusEvent(id: UUID(), title: title, details: "New MCRI learning event", category: category, start: date, deadline: date.addingTimeInterval(-3600), location: location, capacity: capacity, points: 30, facilitatorID: id)
                    if store.createEvent(event) { dismiss() }
                }.buttonStyle(.borderedProminent)
            }.navigationTitle("New event").toolbar { Button("Close") { dismiss() } }
        }
    }
}

#Preview {
    RootView().environmentObject(CampusStore())
}
