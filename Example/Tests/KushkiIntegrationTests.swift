import XCTest
@testable import kushki_ios

class KushkiIntegrationTests: XCTestCase {

    let tokenLength = 32
    let successfulCode = "000"
    let successfulMessage = "Transacción aprobada"
    let invalidCardCode = "017"
    let invalidCardMessage = "Tarjeta no válida"
    var publicMerchantId: String?
    var kushki: Kushki?
    var totalAmount: Double?
    var transaction: Transaction?

    override func setUp() {
        super.setUp()
        publicMerchantId = "10000001641125237535111218"
        totalAmount = 10.0
        kushki = Kushki(publicMerchantId: publicMerchantId!, currency: "USD", environment: KushkiEnvironment.testing)
        transaction = Transaction(code: "", text: "", token: "")
    }

    func testReturnsTokenWhenCalledWithValidParams() {
        let asyncExpectation = expectation(description: "requestToken")
        let card = Card(name: "John Doe", number: "4242424242424242", cvv: "123", expiryMonth: "12", expiryYear: "21")
        kushki!.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertEqual(self.tokenLength, self.transaction!.token.characters.count)
            XCTAssertEqual(self.successfulCode, self.transaction!.code)
            XCTAssertEqual(self.successfulMessage, self.transaction!.text)
            XCTAssertTrue(self.transaction!.isSucessful())
        }
    }

    func testDoesNotReturnTokenWhenCalledWithInvalidParams() {
        let asyncExpectation = expectation(description: "requestToken")
        let card = Card(name: "Invalid John Doe", number: "000000", cvv: "123", expiryMonth: "12", expiryYear: "21")
        kushki!.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertEqual("", self.transaction!.token)
            XCTAssertEqual(self.invalidCardCode, self.transaction!.code)
            XCTAssertEqual(self.invalidCardMessage, self.transaction!.text)
            XCTAssertFalse(self.transaction!.isSucessful())
        }
    }
}
