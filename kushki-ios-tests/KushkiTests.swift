import XCTest
@testable import kushki_ios

class KushkiTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReturnsTokenWhenCalledWithValidParams() {
        // let card = Card(name: "John Doe", number: "4242424242424242", cvv: "123", expiryMonth: "12", expiryYear: "21")
        let params = Helpers.randomAlphanumeric(32)
        let encryptedMessage = Helpers.randomAlphanumeric(64)
        let aurusEncryption = AurusEncryptionStub(whenEncryptCalledWith: params, thenReturn: encryptedMessage)
        let kushki = Kushki(publicMerchantId: "123",
                            currency: "USD",
                            environment: KushkiEnvironment.testing,
                            aurusEncryption: aurusEncryption)
        let result = kushki.requestToken(params)
        XCTAssertEqual(encryptedMessage, result)
    }
}

private class AurusEncryptionStub: AurusEncryption {
    let expectedEncryptParam: String
    let encryptReturnValue: String
    
    init(whenEncryptCalledWith: String, thenReturn: String) {
        expectedEncryptParam = whenEncryptCalledWith
        encryptReturnValue = thenReturn
    }
    
    override func encrypt(_ requestMessage: String) -> String {
        if requestMessage == expectedEncryptParam {
            return encryptReturnValue
        }
        return "Stub called with unexpected params"
    }
}
