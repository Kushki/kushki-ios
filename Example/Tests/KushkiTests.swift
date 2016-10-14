import XCTest
import OHHTTPStubs
@testable import Kushki

class KushkiTests: XCTestCase {

    var publicMerchantId: String?
    var totalAmount: Double?

    override func setUp() {
        super.setUp()
        publicMerchantId = "10000001436354684173102102"
        totalAmount = 10.0
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReturnsTokenWhenCalledWithValidParams() {
        let asyncExpectation = expectation(description: "requestToken")
        let card = Card(name: "John Doe", number: "4242424242424242", cvv: "123", expiryMonth: "12", expiryYear: "21")
        let encryptedMessage = Helpers.randomAlphanumeric(64)
        let expectedToken = Helpers.randomAlphanumeric(32)
        let expectedRequestMessage = buildRequestMessage(withMerchantId: publicMerchantId!, withCard: card, withAmount: totalAmount!)
        let aurusEncryption = AurusEncryptionStub(whenEncryptCalledWith: expectedRequestMessage, thenReturn: encryptedMessage)
        let expectedRequestBody = "{\"request\": \"" + encryptedMessage + "\"}"
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "USD",
                            environment: KushkiEnvironment.testing,
                            aurusEncryption: aurusEncryption)
        _ = stub(condition: isHost("uat.aurusinc.com")
            && isPath("/kushki/api/v1/tokens")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                let requestBody = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                XCTAssertEqual(expectedRequestBody, requestBody)
                let responseBody = [
                    "response_code": "000",
                    "response_text": "Transacción aprobada",
                    "transaction_token_validity": "1800000",
                    "transaction_token": expectedToken
                ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        var transaction = Transaction(code: "", message: "", token: "")
        kushki.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(expectedToken, transaction.token)
            XCTAssertTrue(transaction.isSuccessful())
        }
    }

    func testDoesNotReturnTokenWhenCalledWithInvalidParams() {
        let asyncExpectation = expectation(description: "requestToken")
        let card = Card(name: "Invalid John Doe", number: "000000", cvv: "123", expiryMonth: "12", expiryYear: "21")
        let encryptedMessage = Helpers.randomAlphanumeric(64)
        let expectedRequestMessage = buildRequestMessage(withMerchantId: publicMerchantId!, withCard: card, withAmount: totalAmount!)
        let aurusEncryption = AurusEncryptionStub(whenEncryptCalledWith: expectedRequestMessage, thenReturn: encryptedMessage)
        let expectedRequestBody = "{\"request\": \"" + encryptedMessage + "\"}"
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "USD",
                            environment: KushkiEnvironment.testing,
                            aurusEncryption: aurusEncryption)
        _ = stub(condition: isHost("uat.aurusinc.com")
            && isPath("/kushki/api/v1/tokens")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                let requestBody = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                XCTAssertEqual(expectedRequestBody, requestBody)
                let responseBody = [
                    "response_code": "017",
                    "response_text": "Tarjeta no válida",
                    "transaction_token_validity": "",
                    "transaction_token": ""
                ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 402, headers: nil)
        }
        var transaction = Transaction(code: "", message: "", token: "")
        kushki.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertEqual("", transaction.token)
            XCTAssertFalse(transaction.isSuccessful())
        }
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
