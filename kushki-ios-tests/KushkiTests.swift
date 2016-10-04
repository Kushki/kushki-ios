import XCTest
import OHHTTPStubs
@testable import kushki_ios

class KushkiTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReturnsTokenWhenCalledWithValidParams() {
        let totalAmount = 10.0
        let card = Card(name: "John Doe", number: "4242424242424242", cvv: "123", expiryMonth: "12", expiryYear: "21")
        let encryptedMessage = Helpers.randomAlphanumeric(64)
        let expectedToken = Helpers.randomAlphanumeric(32)
        let aurusEncryption = AurusEncryptionStub(whenEncryptCalledWith: "", thenReturn: encryptedMessage)
        let kushki = Kushki(publicMerchantId: "123",
                            currency: "USD",
                            environment: KushkiEnvironment.testing,
                            aurusEncryption: aurusEncryption)
        stub(isHost("uat.aurusinc.com")) { _ in
            let responseBody = [
                "response_code": "000",
                "response_text": "Transacción aprobada",
                "transaction_token_validity": "1800000",
                "transaction_token": expectedToken
            ]
            return OHHTTPStubsResponse(JSONObject: responseBody, statusCode: 200, headers: nil)
        }
        let result = kushki.requestToken(card: card, totalAmount: totalAmount)
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
