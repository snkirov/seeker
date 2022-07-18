// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Seeker",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Seeker",
            targets: ["Seeker"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/snkirov/swift-log-elk.git", from: "0.2.3"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.2.0"),
        .package(url: "https://github.com/snkirov/SwiftPrometheusPushGateway.git", from: "1.0.1"),
        .package(url: "https://github.com/snkirov/opentelemetry-swift-ios.git", from: "0.2.1"),
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", .upToNextMinor(from: "0.3.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Seeker", dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Metrics", package: "swift-metrics"),
                .product(name: "Tracing", package: "swift-distributed-tracing"),
                .product(name: "LoggingELK", package: "swift-log-elk"),
                .product(name: "SwiftPrometheus", package: "SwiftPrometheusPushGateway"),
                .product(name: "OpenTelemetry", package: "opentelemetry-swift-ios"),
                .product(name: "OtlpGRPCSpanExporting", package: "opentelemetry-swift-ios"),
            ]),
        .testTarget(
            name: "SeekerTests",
            dependencies: [
                .target(name: "Seeker")
            ]),
    ]
)
