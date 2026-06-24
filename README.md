# ShareID iOS SDK — Swift Package Manager

Distribution SPM du SDK ShareID. Le binaire (`shareid_sdk_ios.xcframework`) est
hébergé sur Nexus, exactement comme pour CocoaPods. Seul le manifeste `Package.swift`
vit dans ce dépôt ; il est mis à jour automatiquement à chaque release par les scripts
`ios-push-spm.sh` / `ios-push-all.sh`.

## Intégration côté client

### 1. Configurer l'accès Nexus (`~/.netrc`)

Le binaire est protégé. Avant d'ajouter le package, le client crée `~/.netrc` :

```
machine repository.shareid.net
  login <user-fourni-par-shareid>
  password <token-fourni-par-shareid>
```

```bash
chmod 600 ~/.netrc
```

Xcode et SwiftPM lisent ce fichier pour télécharger le `binaryTarget`. C'est l'équivalent
exact des creds Nexus utilisés en CocoaPods.

### 2. Ajouter le package dans Xcode

`File > Add Package Dependencies…` puis l'URL de ce dépôt, et choisir la version (tag SemVer).

Ou dans un `Package.swift` consommateur :

```swift
.package(url: "https://github.com/ShareID-ai/shareid-sdk-ios-spm.git", from: "2.7.13")
```

Puis ajouter le produit `ShareID` à la cible.

### 3. Utilisation

```swift
import ShareID
// ou, identique à CocoaPods :
import shareid_sdk_ios
```

OpenSSL est résolu automatiquement par SPM (dépendance déclarée dans `Package.swift`).

## Publication (interne)

Ne pas éditer `url` / `checksum` à la main : utiliser `ios-push-spm.sh` (SPM seul) ou
`ios-push-all.sh` (CocoaPods + SPM). Ils calculent le checksum du zip Nexus, réécrivent
`Package.swift`, committent et créent le tag `X.Y.Z`.
