// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "file-reader-async-example",
  platforms: [
    .macOS(.v12)
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .executable(name: "log-example", targets: ["LogExampleCLI"])
  ],
  dependencies: [
    .package(url: "https://github.com/JohnSundell/Files", from: "4.2.0"),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.2"),
    .package(url: "https://github.com/apple/swift-format.git", branch: "main"),
    .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.1"),
  ],
  targets: [
    .executableTarget(
      name: "LogExampleCLI",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "Files",
        "Rainbow",
      ]
    )
  ]
)
