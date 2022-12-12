// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Puzzle",
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.4"),
  ],
  targets: [
    .executableTarget(
      name: "Puzzle",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Algorithms", package: "swift-algorithms"),
        .product(name: "Collections", package: "swift-collections"),
      ]),
    .testTarget(name: "PuzzleTests", dependencies: ["Puzzle"]),
  ]
)
