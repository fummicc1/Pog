// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Shared",
	platforms: [.iOS(
		.v17
	)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "Models",
			targets: ["Models"]
		),
		.library(
			name: "DataStore",
			targets: ["DataStore"]
		),
		.library(
			name: "Repositories",
			targets: ["Repositories"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/pointfreeco/swift-composable-architecture",
			.upToNextMajor(
				from: "1.6.0"
			)
		),
		.package(
			url: "https://github.com/realm/realm-swift",
			.upToNextMajor(
				from: "10.45.3"
			)
		),
		.package(
			url: "https://github.com/fummicc1/RealmSwiftMacro",
			branch: "main"
		)
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "Models",
			dependencies: []
		),
		.testTarget(
			name: "ModelsTests",
			dependencies: ["Models"]
		),
		.target(
			name: "DataStore",
			dependencies: [
				"Models",
				"Repositories",
				.product(
					name: "RealmSwiftMacro",
					package: "RealmSwiftMacro"
				),
				.product(
					name: "RealmSwift",
					package: "realm-swift"
				),
				.product(
					name: "Realm",
					package: "realm-swift"
				),
			]
		),
		.target(
			name: "Repositories",
			dependencies: [
				"Models"
			]
		)
	]
)
