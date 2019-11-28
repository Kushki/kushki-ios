import Foundation

class Helpers {

    // Source: http://stackoverflow.com/a/34316795
    static func randomAlphanumeric(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let lettersLength = UInt32(letters.count)

        let randomCharacters = (0..<length).map { _ -> Character in
            let offset = Int(arc4random_uniform(lettersLength))
            return letters[letters.index(letters.startIndex, offsetBy: offset)]
        }

        return String(randomCharacters)
    }

}
