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
        // Équivalent SPM de la pod "OpenSSL-Universal ~> 1.1.2301".
        // Même projet / même auteur que la pod : les numéros de version sont alignés.
        // → À ajuster si tu changes de version d'OpenSSL côté SDK.
        .package(url: "https://github.com/krzyzanowskim/OpenSSL.git", from: "1.1.2301")
    ],
    targets: [
        // Le binaire, hébergé sur Nexus, gardé par les creds .netrc CÔTÉ CLIENT.
        // `url` et `checksum` sont réécrits automatiquement par ios-push-spm.sh / ios-push-all.sh.
        .binaryTarget(
            name: "shareid_sdk_ios",
            url: "https://repository.shareid.net/repository/raw-hosted/bind2/iOS/2.7.13/shareid_sdk_ios.zip",
            checksum: "0000000000000000000000000000000000000000000000000000000000000000"
        ),
        // Un binaryTarget ne peut pas déclarer de dépendances : ce wrapper sert à
        // lier OpenSSL et à ré-exporter le binaire (cf. Sources/ShareID/Exports.swift).
        .target(
            name: "ShareID",
            dependencies: [
                "shareid_sdk_ios",
                .product(name: "OpenSSL", package: "OpenSSL")
            ]
        )
    ]
)
