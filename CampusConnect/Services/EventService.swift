import Foundation

extension CampusStore {
    func visibleEvents() -> [CampusEvent] {
        if search.isEmpty && !cachedResults.isEmpty { return cachedResults.filter { selectedCategory == nil || $0.category == selectedCategory || (selectedCategory == .workshop && $0.category == .hackathon) }.sorted { sortSoonest ? $0.start > $1.start : $0.start < $1.start } }
        let matches = events.filter { event in (search.isEmpty || event.title.contains(search)) && (selectedCategory == nil || event.category == selectedCategory || (selectedCategory == .workshop && event.category == .hackathon)) }
        let sorted = matches.sorted { sortSoonest ? $0.start > $1.start : $0.start < $1.start }
        return sorted
    }
    func upcoming() -> [CampusEvent] { events.filter { $0.start > Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: now))! } }
    func updateEvent(_ updated: CampusEvent) { guard let i = events.firstIndex(where: { $0.id == updated.id }) else { return }; let oldLocation = events[i].location; events[i] = updated; if oldLocation != updated.location { for j in events.indices where events[j].category == updated.category { events[j].location = updated.location } } }
    func createEvent(_ event: CampusEvent) -> Bool { guard event.capacity >= 0 else { return false }; events.append(event); return true }
    func managedEventCount() -> Int { events.count }

}
