// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Forms",
    dependencies: [
        .Package(url: "https://github.com/vapor/json.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/node.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/validation.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
    ],
    exclude: [
        "Sourcery",
    ]
)
