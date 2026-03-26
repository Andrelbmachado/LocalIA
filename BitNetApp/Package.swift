// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BitNetApp",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "BitNetApp",
            targets: ["BitNetApp"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BitNetApp",
            dependencies: ["BitNetCore"],
            path: "Sources/App",
            resources: [.process("Resources")]
        ),
        .target(
            name: "BitNetCore",
            dependencies: [],
            path: "Sources/Core",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("../../../BitNet/include"),
                .headerSearchPath("../../../BitNet/src"),
                .define("GGML_USE_ACCELERATE"),
            ],
            cxxSettings: [
                .headerSearchPath("../../../BitNet/include"),
                .headerSearchPath("../../../BitNet/src"),
            ],
            linkerSettings: [
                .linkedFramework("Accelerate"),
                .linkedFramework("Foundation"),
                .linkedFramework("Metal"),
                .linkedFramework("MetalKit")
            ]
        ),
        .testTarget(
            name: "BitNetAppTests",
            dependencies: ["BitNetApp"]
        ),
    ],
    cxxLanguageStandard: .cxx17
)
