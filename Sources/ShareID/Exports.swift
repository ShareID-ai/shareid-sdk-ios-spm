// Ré-exporte le module binaire pour que le client puisse écrire `import ShareID`.
// Son code existant `import shareid_sdk_ios` (identique à CocoaPods) continue aussi de fonctionner :
// dans les deux cas, ajouter le produit "ShareID" à la cible lie également OpenSSL.
@_exported import shareid_sdk_ios
