// swift-tools-version: 5.9
import PackageDescription
let package = Package(
    name: "CampusConnectVerification",
    platforms: [.macOS(.v13)],
    products: [.library(name: "CampusCore", targets: ["CampusCore"])],
    targets: [
        .target(name: "CampusCore", path: "CampusConnect", exclude: ["App", "Views", "Resources", "Components"], sources: ["Models", "ViewModels", "Services", "Repositories", "Utilities"]),
        .testTarget(name: "SmokeTests", dependencies: ["CampusCore"], path: "instructor/Tests/SmokeTests"),
        .testTarget(name: "DefectVerificationTests", dependencies: ["CampusCore"], path: "instructor/Tests/DefectVerificationTests")
    ]
)
