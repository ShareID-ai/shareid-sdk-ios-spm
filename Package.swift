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
            url: "https://repository.shareid.net/repository/raw-hosted/bind2/iOS/2.8.4/shareid_sdk_ios.zip",
            checksum: "700bf1f85c6365a9222eb56a4098615eea6323ce08dd65140ee74792189d78c7"
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
