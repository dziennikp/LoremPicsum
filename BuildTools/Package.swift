// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BuildTools",
    dependencies: [
        // Define any tools you want available from your build phases
        // Here's an example with SwiftFormat
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.41.2"),
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
