// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "ShareID",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "ShareID", targets: ["ShareID"])
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/OpenSSL.git", from: "1.1.2301")
    ],
    targets: [
        .binaryTarget(
            name: "shareid_sdk_ios",
            url: "https://repository.shareid.net/repository/raw-hosted/bind2/iOS/2.8.0/shareid_sdk_ios.zip",
            checksum: "b4c07af720e79b3590b493f0271a5e0924b5c9ad5d9f96dea49aae065d8eadf2"
        ),
        .target(
            name: "ShareID",
            dependencies: [
                "shareid_sdk_ios",
                .product(name: "OpenSSL", package: "OpenSSL")
            ]
        )
    ]
)
