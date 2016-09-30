import Foundation
import SwiftyRSA

class AurusEncryption {
    
    static let chunkSize = 117
    
    
    init() {
        let publickey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC81t5iu5C0JxYq5/XNPiD5ol3Zw8rw3LtFIUm7y3m8o8wv5qVnzGh6XwQ8LWypdkbBDKWZZrAUd3lybZOP7/82Nb1/noYj8ixVRdbnYtbsSAbu9PxjB7a/7LCGKsugLkou74PJDadQweM88kzQOx/kzAyVbS9gCCVUguHcq2vRRQIDAQAB"
        // var encryptedString = try! SwiftyRSA.encryptString()
    }
    
    func encryptMessageChunk(_ requestMessage: String) -> String {
        var index = 0
        return ""
    }
    
    private func getNextChunk(_ requestMessage: String, _ start: Int) -> String {
        let end = min(start + self.chunkSize, requestMessage.characters.count)
        let startRange = requestMessage.startIndex.advancedBy(start)
        let endRange = startRange.advancedBy(end)
        return requestMessage.substringWithRange(startRange..<endRange)
    }


}
