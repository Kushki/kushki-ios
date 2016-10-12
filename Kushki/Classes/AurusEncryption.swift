class AurusEncryption {
    
    static let chunkSize = 117
    static let publicKeyPem = "-----BEGIN PUBLIC KEY-----" +
        "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC81t5iu5C0JxYq5/XNPiD5ol3Z" +
        "w8rw3LtFIUm7y3m8o8wv5qVnzGh6XwQ8LWypdkbBDKWZZrAUd3lybZOP7/82Nb1/" +
        "noYj8ixVRdbnYtbsSAbu9PxjB7a/7LCGKsugLkou74PJDadQweM88kzQOx/kzAyV" +
        "bS9gCCVUguHcq2vRRQIDAQAB" +
        "-----END PUBLIC KEY-----"


    func encrypt(_ requestMessage: String) -> String {
        var index = 0
        var result = ""
        while index < requestMessage.characters.count {
            let chunk = getNextChunk(requestMessage, index)
            let encryptedChunk = try! RSAUtils.encryptWithRSAPublicKey(str: chunk, pubkeyBase64: AurusEncryption.publicKeyPem)
            let encodedChunk = encryptedChunk!.base64EncodedString(options: [])
            result += encodedChunk + "<FS>"
            index += AurusEncryption.chunkSize
            
        }
        return result
    }

    private func getNextChunk(_ requestMessage: String, _ index: Int) -> String {
        let end = min(index + AurusEncryption.chunkSize, requestMessage.characters.count)
        let startIndex = requestMessage.index(requestMessage.startIndex, offsetBy: index)
        let endIndex = requestMessage.index(requestMessage.startIndex, offsetBy: end)
        return requestMessage[startIndex..<endIndex]
    }
}
