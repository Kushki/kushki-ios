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
        let publicMerchantId = "10000001436354684173102102"
        let totalAmount = 10.0
        let card = Card(name: "John Doe", number: "4242424242424242", cvv: "123", expiryMonth: "12", expiryYear: "21")
        let encryptedMessage = Helpers.randomAlphanumeric(64)
        let expectedToken = Helpers.randomAlphanumeric(32)
        let expectedRequestMessage = buildRequestMessage(withMerchantId: publicMerchantId, withCard: card, withAmount: totalAmount)
        let aurusEncryption = AurusEncryptionStub(whenEncryptCalledWith: expectedRequestMessage, thenReturn: encryptedMessage)
        let expectedRequestBody = "{\"request\": \"" + encryptedMessage + "\"}"
        let kushki = Kushki(publicMerchantId: publicMerchantId,
                            currency: "USD",
                            environment: KushkiEnvironment.testing,
                            aurusEncryption: aurusEncryption)
        stub(condition: isHost("uat.aurusinc.com")
            && isPath("/kushki/api/v1/tokens")
            && isMethodPOST()) { request in
                //let requestBody = String(data: request.httpBody!, encoding: .utf8)
                //if requestBody != expectedRequestBody {
                //    return OHHTTPStubsResponse(jsonObject: [], statusCode: 500, headers: nil)
                //}
                //print(requestBody) // delete this
                let responseBody = [
                    "response_code": "000",
                    "response_text": "Transacción aprobada",
                    "transaction_token_validity": "1800000",
                    "transaction_token": expectedToken
                ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        kushki.requestToken(card: card, totalAmount: totalAmount) { transaction in
            print("HOLAAAA", transaction.token)
            XCTAssertEqual(expectedToken, transaction.token)
            XCTAssertTrue(transaction.isSucessful())
            XCTAssertTrue(false)
        }
        XCTAssertTrue(false)

    }
    
    private func buildRequestMessage(withMerchantId publicMerchantId: String, withCard card: Card, withAmount totalAmount: Double) -> String {
        let requestDictionary:[String : Any] = [
            "merchant_identifier": publicMerchantId,
            "language_indicator": "es",
            "card": [
                "name": card.name,
                "number": card.number,
                "expiry_month": card.expiryMonth,
                "expiry_year": card.expiryYear,
                "cvv": card.cvv,
                "card_present": "1"
            ],
            "amount": String(format: "%.2f", totalAmount),
            "remember_me": "0",
            "deferred_payment": "0",
            "token_type": "transaction-token"
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.ascii)
        return dictFromJson!
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
