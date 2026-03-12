// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "PaperTrailLumberjack",

    platforms: [
        .iOS(.v8),
        .macOS(.v10_10),
    ],

    products: [
        .library(name: "PaperTrailLumberjack", targets: ["PaperTrailLumberjack"]),
    ],

    dependencies: [
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.8.0"),
        .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket.git", from: "7.6.5"),
    ],

    targets: [
        .target(
            name: "PaperTrailLumberjack",
            dependencies: [
                "CocoaLumberjack",
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
                "CocoaAsyncSocket",
            ],
            path: "Classes",
            publicHeadersPath: "."
        ),
    ]
)
