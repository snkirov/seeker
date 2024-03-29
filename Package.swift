// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Seeker",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Seeker",
            targets: ["Seeker"]),
        .library(
            name: "Default Configuration",
            targets: ["Default Configuration"]),
        .library(
            name: "LoggingELK Integration",
            targets: ["LoggingELK Integration"]),
        .library(
            name: "SwiftPrometheus Integration",
            targets: ["SwiftPrometheus Integration"]),
        .library(
            name: "OpenTelemetry Integration",
            targets: ["OpenTelemetry Integration"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/Apodini/swift-log-elk", branch: "develop"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.2.0"),
        .package(url: "https://github.com/snkirov/SwiftPrometheusPushGateway.git", from: "1.0.1"),
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/slashmo/opentelemetry-swift", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Seeker", dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Metrics", package: "swift-metrics"),
                .product(name: "Tracing", package: "swift-distributed-tracing"),
            ]),
        .target(name: "Default Configuration", dependencies: [
            .target(name: "LoggingELK Integration"),
            .target(name: "SwiftPrometheus Integration"),
            .target(name: "OpenTelemetry Integration")
        ]),
        .target(name: "LoggingELK Integration", dependencies: [
            .target(name: "Seeker"),
            .product(name: "LoggingELK", package: "swift-log-elk")
        ]),
        .target(name: "SwiftPrometheus Integration", dependencies: [
            .target(name: "Seeker"),
            .product(name: "SwiftPrometheus", package: "SwiftPrometheusPushGateway")
        ]),
        .target(name: "OpenTelemetry Integration", dependencies: [
            .target(name: "Seeker"),
            .product(name: "OpenTelemetry", package: "opentelemetry-swift"),
            .product(name: "OtlpGRPCSpanExporting", package: "opentelemetry-swift")
        ]),
        .testTarget(
            name: "SeekerTests",
            dependencies: [
                .target(name: "Default Configuration")
            ]),
    ]
)
