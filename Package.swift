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
            url: "https://repository.shareid.net/repository/raw-hosted/bind2/iOS/2.8.1/shareid_sdk_ios.zip",
            checksum: "99aeebf5de8550e7c443ed7d72d1cbb617c4445d673881e5f959b61af9988b2d"
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
