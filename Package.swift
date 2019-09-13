// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RxAlamofire",
  platforms: [
    .macOS(.v10_10), .iOS(.v8), .tvOS(.v9), .watchOS(.v3)
  ],
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(
      name: "RxAlamofire",
      targets: ["RxAlamofire"]),
  ],
  
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "4.8.2")),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.1" ),
  ],
  
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(
      name: "RxAlamofire",
      dependencies: ["RxSwift", "Alamofire", "RxCocoa"],
      path: "Sources")
  ],
  swiftLanguageVersions: [.v5]
)

