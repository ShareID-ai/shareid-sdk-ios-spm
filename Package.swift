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
            url: "https://repository.shareid.net/repository/raw-hosted/bind2/iOS/2.7.14/shareid_sdk_ios.zip",
            checksum: "ce72470ed56d2cb835188bcf6338f376e79dbfd173959111e3d3d2f233e11468"
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
