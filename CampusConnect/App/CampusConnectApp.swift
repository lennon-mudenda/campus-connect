import SwiftUI

@main
struct CampusConnectApp: App {
    @StateObject private var store = CampusStore()
    var body: some Scene {
        WindowGroup { RootView().environmentObject(store) }
    }
}
