// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Alloy",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(name: "Alloy",
                 targets: ["Alloy","AlloyShadersSharedTypes"]),
    ],
    targets: [
        .target(name: "AlloyShadersSharedTypes",
                publicHeadersPath: "."),
        .target(name: "Alloy",
                dependencies: [.target(name: "AlloyShadersSharedTypes")],
                resources: [.process("Shaders/Shaders.metal")]),
        .target(name: "AlloyTestsResources",
                path: "Tests/AlloyTestsResources",
                resources: [
                    .copy("Shared"),
                    .copy("TextureCopy")
                ]),
        .testTarget(name: "AlloyTests",
                    dependencies: ["Alloy", "AlloyTestsResources"],
                    resources: [.process("Shaders/Shaders.metal")])
    ]
)
