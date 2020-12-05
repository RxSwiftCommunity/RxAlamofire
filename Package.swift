// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "RxAlamofire",
                      platforms: [
                        .macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3)
                      ],
                      products: [
                        // Products define the executables and libraries produced by a package, and make them visible to other packages.
                        .library(name: "RxAlamofire",
                                 targets: ["RxAlamofire"])
                      ],

                      dependencies: [
                        // Dependencies declare other packages that this package depends on.
                        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.1")),
                        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
                        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", .upToNextMajor(from: "9.1.0"))
                      ],

                      targets: [
                        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
                        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
                        .target(name: "RxAlamofire",
                                dependencies: [
                                  .product(name: "RxSwift", package: "RxSwift"),
                                  .product(name: "Alamofire", package: "Alamofire"),
                                  .product(name: "RxCocoa", package: "RxSwift")
                                ],
                                path: "Sources"),
                        .testTarget(name: "RxAlamofireTests",
                                    dependencies: [
                                      .byName(name: "RxAlamofire"),
                                      .product(name: "RxBlocking", package: "RxSwift"),
                                      .product(name: "OHHTTPStubs", package: "OHHTTPStubs"),
                                      .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
                                    ])
                      ],
                      swiftLanguageVersions: [.v5])
