// swift-tools-version: 5.9
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "RemoSwift",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(name: "RemoSwift", targets: ["RemoSwift"]),
        .library(name: "RemoObjC", targets: ["RemoObjC"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0"),
    ],
    targets: [
        .binaryTarget(name: "CRemo", url: "https://github.com/yjmeqt/Remo/releases/download/v0.4.4/RemoSDK.xcframework.zip", checksum: "332220bc05f694dd6e3892b33bd651bf2f0fb2056e3a1129987fa0de12140497"),
        .macro(
            name: "RemoMacrosPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "RemoMacros",
            dependencies: ["RemoMacrosPlugin"]
        ),
        .target(
            name: "RemoSwift",
            dependencies: [
                .target(name: "CRemo", condition: .when(platforms: [.iOS])),
                "RemoMacros",
            ],
            path: "Sources/RemoSwift",
            linkerSettings: [
                .linkedLibrary("c++", .when(platforms: [.iOS])),
                .linkedFramework("Security", .when(platforms: [.iOS])),
                .linkedFramework("CoreMedia", .when(platforms: [.iOS])),
                .linkedFramework("VideoToolbox", .when(platforms: [.iOS])),
                .linkedFramework("CoreFoundation", .when(platforms: [.iOS])),
            ]
        ),
        .target(
            name: "RemoObjC",
            dependencies: [
                .target(name: "CRemo", condition: .when(platforms: [.iOS])),
            ],
            path: "Sources/RemoObjC",
            publicHeadersPath: "include",
            linkerSettings: [
                .linkedLibrary("c++", .when(platforms: [.iOS])),
                .linkedFramework("Security", .when(platforms: [.iOS])),
                .linkedFramework("CoreMedia", .when(platforms: [.iOS])),
                .linkedFramework("VideoToolbox", .when(platforms: [.iOS])),
                .linkedFramework("CoreFoundation", .when(platforms: [.iOS])),
            ]
        ),
        .testTarget(
            name: "RemoMacrosTests",
            dependencies: [
                "RemoMacros",
                "RemoMacrosPlugin",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
