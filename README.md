# ShareID iOS <a id="ios"></a>

 [Latest version](https://doc.shareid.ai/changelog/sdk-ios/)

## Getting started <a id="getting-started"></a>

In order to perform an Onboarding or an Authenticate, you should follow those steps:

1. [Set up the SDK](#set-up-the-sdk): install and import the SDK
2. [Get a token](#get-a-token): request a token using your business credentials
3. [Start an onboarding or authenticate flow](#start-an-onboarding-or-authenticate-flow): launch a user workflow
4. [Get the user workflow result from SDK](#get-the-user-workflow-result-from-sdk): use the Message handler to get insights about the user workflow
5. [Get the Analysis result](#get-the-analysis-result): use your callback or the endpoint to get the analysis result

---

### 1. Set up the SDK <a id="set-up-the-sdk"></a>

#### 1.1. Project requirements <a id="project-requirements"></a>

The proper functioning of the SDK necessitates the provision of several parameters. These parameters are essential for enabling the full range of functionalities offered by the SDK.

* **iOS 15+** (because of Swift minimum version)
* Available for iPhone and iPad in **portrait** mode only

> [!WARNING]
> ##### 📸 Mandatory for camera permissions
> 
> The SDK uses the device's **camera** functionalities.
> You must add the following key in your application's `Info.plist` file:
>   - `NSCameraUsageDescription` – for camera access (see [Apple documentation](https://developer.apple.com/documentation/avfoundation/capture_setup/requesting_authorization_to_capture_and_save_media) for more details)
>
> Example:
>
> ```xml
> <key>NSCameraUsageDescription</key>
> <string>This app requires access to the camera for identity verification.</string>
> ```

> [!WARNING]
> ##### 📡 NFC Permissions and Capabilities
>
> The SDK requires access to the device's **NFC** features.
>
> **1. Enable NFC capability**
>
> - Activate **Near Field Communication Tag Reading** for your App ID in the [Apple Developer Portal](https://developer.apple.com/account/resources/identifiers/list).
> - In **Xcode → Signing & Capabilities**, add **Near Field Communication Tag Reading**. *(Xcode will automatically include the necessary entitlement in your `.entitlements` file.)*
> - In your `Info.plist`, define a clear and explicit usage message for `NFCReaderUsageDescription`.
>
> Example:
>
> ```xml
> <key>NFCReaderUsageDescription</key>
> <string>This app requires access to NFC to read identity documents.</string>
> ```
>
> **2. Configure entitlements**
>
> If your app needs to support specific NFC protocols or identifiers (such as **ISO7816**, **AID**, or **NDEF**), extend your entitlements as shown below.
> 
> Example – `.entitlements` file:
> 
> ```xml
> <?xml version="1.0" encoding="UTF-8"?>
> <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
> <plist version="1.0">
> <dict>
>     <key>com.apple.developer.nfc.readersession.formats</key>
>     <array>
>         <string>TAG</string>
>         <string>PACE</string>
>     </array>
> </dict>
> </plist>
> ```
> 
> **3. Add supported identifiers**
> 
> If required, you can also define additional supported identifiers directly in your `Info.plist`. These are not mandatory but may be necessary for advanced use cases.
> 
> Example – `Info.plist`:
> 
> ```xml
> <key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
> <array>
>     <string>A0000002471001</string>
>     <string>A0000002472001</string>
>     <string>D4100000030001</string>
>     <string>D2760000850101</string>
> </array>
> ```
> 
> For more details, refer to Apple's [CoreNFC documentation](https://developer.apple.com/documentation/corenfc).

> [!NOTE]
> The **Camera** permission is **mandatory** for all SDK functionalities. The **NFC** permission is **optional** and only required if the credentials include access to NFC functionality.

#### 1.2. Install SDK <a id="install-sdk"></a>

ShareID supports [CocoaPods](https://cocoapods.org) and **Swift Package Manager (SPM)**, with authentication handled via a `.netrc` file.

To securely manage your credentials, you'll need to create a `.netrc` file in your home directory with the necessary login details.

1. Create and open

Type `touch ~/.netrc & open ~/.netrc`

2. Add login details

```sh
machine repository.shareid.net
login <your-repository-username>
password <your-repository-password>
```

3. Set file permissions

`chmod 600 ~/.netrc`

#### 1.3. Add the dependency <a id="add-the-dependency"></a>

Choose the integration method that fits your project. Both read the same Nexus credentials from your `.netrc` file.

##### CocoaPods

To install the SDK with CocoaPods, you'll need to add the dependency to your `Podfile`. (if it doesn't exist, create one by running the following command in your project directory: `pod init`)

1. Add the following to your target

```ruby
platform :ios, '15.0'

target '<your-app>' do
  use_frameworks!
  pod 'shareid-sdk-ios' # or specific version
end
```

2. Run `pod install` to install the dependency
3. Now, you can import and use the SDK in your project

```swift
import shareid_sdk_ios
```

##### Swift Package Manager

The binary (`shareid_sdk_ios.xcframework`) is hosted on Nexus and downloaded using the same `.netrc` credentials as CocoaPods. Only the `Package.swift` manifest lives in the SPM repository.

**In Xcode**

1. `File > Add Package Dependencies…`
2. Enter the package URL and choose the version (SemVer tag):

```
https://github.com/ShareID-ai/shareid-sdk-ios-spm.git
```

3. Add the `ShareID` product to your target.

**Or in a consumer `Package.swift`**

```swift
.package(url: "https://github.com/ShareID-ai/shareid-sdk-ios-spm.git", from: "x.x.x") # or specific version
```

Then import and use the SDK in your project:

```swift
import ShareID
// or
import shareid_sdk_ios
```

### 2. Get a token <a id="get-a-token"></a>

Use the credentials you received from ShareID's team to get an authentication token and launch an onboarding or authenticate workflow.

Depending on the SDK you are integrating (Onboarding/Authenticate), you may use an API here [Get a Token](https://doc.shareid.ai/get-a-token)

### 3. Start an onboarding or authenticate flow <a id="start-an-onboarding-or-authenticate-flow"></a>

Once you have added the SDK as a dependency and have your credentials, you can configure the SDK.

```swift
ShareID.shared.start(service: "<service>", token: "<your-token>")
```

The `service` specifies the service in the SDK:

* `onboarding` starts the onboarding process
* `authenticate` starts the authenticate process

> [!TIP]
> The initial SDK screen is automatically triggered upon execution of the method above.

### 4. Get the user workflow result from SDK <a id="get-the-user-workflow-result-from-sdk"></a>

To receive feedback from the SDK, you need to implement the `messageHandler` closure, which manages various responses from the ShareID process.

This closure is triggered when the ShareID SDK completes an operation, fails, or encounters an error.

```swift
ShareID.shared.messageHandler = { (result: ShareID.Result) in
      switch result.type {
            case .success:
                  // ...
            case .exit:
                  // ...
            case .failure:
                  // ...
      }
}
```

To view all possible end-of-process results in our SDK, please refer to the [Message Handler](https://doc.shareid.ai/sdks/common/message-handler) for all success, exit and failure states.

### 5. Get the analysis result <a id="get-the-analysis-result"></a>

When the processing of an onboarding or authenticate request is finished, you may receive the result through the callback if you provided it. You may also, fetch yourself the result by calling our API.

See [Get the analysis result](https://doc.shareid.ai/get-the-analysis-result/) for more details.

## Customisation <a id="customisation"></a>

The ShareID iOS SDK is built to be highly customisable, allowing for flexibility through various configuration options or by applying themes to adapt the user interface to your needs.

### Configuration <a id="configuration"></a>

##### Theme

To customise the SDK, pass a `ShareID.Theme` after building the flow.

```swift
ShareID.shared.theme = ShareID.Theme.init()
```

**Set the colors**

```swift
theme.colors.primary = ...
theme.colors.secondary = ...
```

| **Name**    | **Message**               | **Color**                                                             |
| ----------- | ------------------------- | --------------------------------------------------------------------- |
| `primary`   | The main color            | ShareID blue (if nothing defined)                                     |
| `secondary` | The main title text color | Black or White (depending on your iPhone theme and if nothing is set) |

##### Language

The SDK uses the device language, but you can use the **`language`** parameter to force a language before initialising the SDK.

```swift
ShareID.shared.language = .en
```

##### Terms & privacy

By default, the SDK will display ShareID's default **Terms** and **Privacy Policy** links.
You can overwrite them with your own URLs by setting them before starting the flow:

```swift
ShareID.shared.terms = URL(string: "https://example.com/terms")!
ShareID.shared.privacy = URL(string: "https://example.com/privacy")!
```

##### Show options

The SDK provides several options to control the display of certain default screens and texts.
You can enable or disable them **before starting the flow**:

```swift
ShareID.shared.shouldShowError = false
ShareID.shared.shouldShowAgreement = false
```

| Parameter               | Default | Description                                                                                                                                                          |
| ----------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **shouldShowError**     | `true`  | Controls whether the SDK automatically displays an error screen when an error occurs. If set to `false`, you must handle errors manually using the response handler. |
| **shouldShowAgreement** | `true`  | Controls whether the default **Agreement screen** is shown at the start of the onboarding process.                                                                   |

> [!WARNING]
> Disabling **`shouldShowError`** exposes the SDK to potential malfunctions if you do not properly handle errors in your application.

##### Auto dismiss

When **`autoDismiss`** is set to `true`, the SDK automatically closes at the end of the flow, returning the user to the initial screen where the SDK was started. By default, this value is set to `true`.

```swift
ShareID.shared.autoDismiss = true
```

##### Verbose

The SDK doesn't display logs in the console by default, but you can decide to display them by setting the verbose variable to `true`.

```swift
ShareID.shared.verbose = true
```

### Localisation <a id="localisation"></a>

Languages supported:

* 🇸🇦 (ar), 🇩🇪 (de), 🇬🇧 (en), 🇪🇸 (es), 🇫🇷 (fr), 🇮🇹 (it), 🇵🇱 (pl), 🇵🇹 (pt), 🇷🇴 (ro), 🇷🇺 (ru), 🇬🇷 (gr)

> [!WARNING]
> Be sure to add `CFBundleLocalizations` to your `Info.plist` file with all the languages you want to support in your application. (This ensures that default Apple buttons are properly localised and enables RTL navigation)

## FAQ <a id="faq"></a>

<details>

<summary>Why do I get a "Sandbox: rsync.samba(XXXXX) deny(1) file-read-data..." error?</summary>

In Xcode 15, a new feature called **User Script Sandboxing** has been introduced to enhance build stability and security by preventing scripts from making unintended changes to the system. When enabled, the build system restricts user scripts from using undeclared input/output dependencies. However, this can cause issues with the ShareID SDK, which requires running scripts to dynamically link dependencies.

To fix this issue:

1. Go to Build Settings > Build Options.
2. Set the **User Script Sandboxing** option to **No**.

</details>
