// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SwiftGravatar",
	platforms: [
		.macOS(.v12), .iOS(.v15)
	],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "SwiftGravatar",
			targets: ["SwiftGravatar"])
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-crypto.git", .upToNextMajor(from: "2.0.0"))
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "SwiftGravatar",
			dependencies: [
				.product(name: "Crypto", package: "swift-crypto")
			]
		),
		.testTarget(
			name: "SwiftGravatarTests",
			dependencies: ["SwiftGravatar"])
	]
)
