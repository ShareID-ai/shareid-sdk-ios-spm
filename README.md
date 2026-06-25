# ShareID iOS SDK — Swift Package Manager

SPM distribution of the ShareID SDK. The binary (`shareid_sdk_ios.xcframework`) is
hosted on Nexus, exactly as it is for CocoaPods. Only the `Package.swift` manifest
lives in this repository.

## Client-side integration

### 1. Configure Nexus access (`~/.netrc`)

The binary is protected. Before adding the package, the client creates `~/.netrc`:

```
machine repository.shareid.net
  login <user-provided-by-shareid>
  password <token-provided-by-shareid>
```

```bash
chmod 600 ~/.netrc
```

Xcode and SwiftPM read this file to download the `binaryTarget`. This is the exact
equivalent of the Nexus credentials used with CocoaPods.

### 2. Add the package in Xcode

`File > Add Package Dependencies…` then enter this repository's URL, and pick the
version (SemVer tag). Or in a consumer `Package.swift`:

```swift
.package(url: "https://github.com/ShareID-ai/shareid-sdk-ios-spm.git", from: "2.7.13")
```

Then add the `ShareID` product to your target.

### 3. Usage

```swift
import ShareID
// or
import shareid_sdk_ios
```
