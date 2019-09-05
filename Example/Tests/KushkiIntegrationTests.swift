import XCTest
@testable import Kushki

class KushkiIntegrationTests: XCTestCase {

    let tokenLength = 32
    let successfulCode = "000"
    let successfulMessage = "Transacción aprobada"
    let invalidCardCode = "017"
    let invalidCardMessage = "Tarjeta no válida"
    let invalidBodyCode = "K001"
    let invalidBodyMessage = "Cuerpo de la petición inválido."
    let invalidBinCode = "K007"
    let invalidBinMessage = "Tarjeta bloqueada por el emisor."
    var publicMerchantId: String?
    var kushki: Kushki?
    var kushkiTransfer:Kushki?
    var kushkiTransferSubscription: Kushki?
    var totalAmount: Double?
    var transaction: Transaction?

    override func setUp() {
        super.setUp()
        publicMerchantId = "10000001641125237535111218"
        totalAmount = 10.0
        kushki = Kushki(publicMerchantId: publicMerchantId!, currency: "USD", environment: KushkiEnvironment.testing)
        kushkiTransfer = Kushki(publicMerchantId: publicMerchantId!, currency: "CLP", environment: KushkiEnvironment.testing)
        kushkiTransferSubscription = Kushki(publicMerchantId: "20000000107468104000", currency: "COP", environment: KushkiEnvironment.testing_ci)
        transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "", biometricInfo: [[:]] as AnyObject)
        
    }

    func testReturnsTokenWhenCalledWithValidParams() {
        let asyncExpectation = expectation(description: "requestToken")
        let card = Card(name: "John Doe", number: "4242424242424242", cvv: "123", expiryMonth: "12", expiryYear: "21")
        kushki!.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 10) { error in
            XCTAssertEqual(self.tokenLength, self.transaction!.token.count)
            XCTAssertTrue(self.transaction!.isSuccessful())
        }
    }
    
    func testDoesNotReturnTokenWhenCalledWithInvalidParams() {
        let asyncExpectation = expectation(description: "requestToken")
        let card = Card(name: "Invalid John Doe", number: "", cvv: "123", expiryMonth: "12", expiryYear: "21")
        kushki!.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertEqual("", self.transaction!.token)
            XCTAssertEqual(self.invalidBodyCode, self.transaction!.code)
            XCTAssertEqual(self.invalidBodyMessage, self.transaction!.message)
            XCTAssertFalse(self.transaction!.isSuccessful())
        }
    }

    func testDoesNotReturnTokenWhenCalledWithInvalidCard() {
        let asyncExpectation = expectation(description: "requestToken")
        let card = Card(name: "Invalid John Doe", number: "000000", cvv: "123", expiryMonth: "12", expiryYear: "21")
        kushki!.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertEqual("", self.transaction!.token)
            XCTAssertEqual(self.invalidBodyCode, self.transaction!.code)
            XCTAssertEqual(self.invalidBodyMessage, self.transaction!.message)
            XCTAssertFalse(self.transaction!.isSuccessful())
        }
    }
    
    func testDoesNotReturnTokenWhenCalledWithInvalidBin() {
        let asyncExpectation = expectation(description: "requestToken")
        let card = Card(name: "Invalid John Doe", number: "4440884457672272", cvv: "123", expiryMonth: "12", expiryYear: "21")
        kushki!.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertEqual("", self.transaction!.token)
            XCTAssertEqual(self.invalidBinCode, self.transaction!.code)
            XCTAssertEqual(self.invalidBinMessage, self.transaction!.message)
            XCTAssertFalse(self.transaction!.isSuccessful())
        }
    }
    
    func testReturnsSubscriptionTokenWhenCalledWithValidParams() {
        let asyncExpectation = expectation(description: "requestSubscriptionToken")
        let card = Card(name: "John Doe", number: "4242424242424242", cvv: "123", expiryMonth: "12", expiryYear: "21")
        kushki!.requestSubscriptionToken(card: card) { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 10) { error in
            XCTAssertEqual(self.tokenLength, self.transaction!.token.count)
            XCTAssertTrue(self.transaction!.isSuccessful())
        }
    }
    
    func testReturnsTransferTokenWhenCalledWithValidParams() {
        let asyncExpectation = expectation(description: "requestTransferToken")
        let amount = Amount(subtotalIva: 12.0, subtotalIva0: 0.0, iva: 1.2 )

        kushkiTransfer!.requestTransferToken(amount: amount, callbackUrl: "www.test.com", userType: "0", documentType: "RUT", documentNumber: "123123123", email: "jose.gonzalez@kushkipagos.com") { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 10) { error in
            XCTAssertEqual(self.tokenLength, self.transaction!.token.count)
            XCTAssertTrue(self.transaction!.isSuccessful())
        }
    }
    
    func testReturnsTransferTokenWhenCalledWithValidAndCompleteParams() {
        let asyncExpectation = expectation(description: "requestTransferToken")
        let amount = Amount(subtotalIva: 12.0, subtotalIva0: 0.0, iva: 1.2 )
        
        kushkiTransfer!.requestTransferToken(amount: amount, callbackUrl: "www.test.com", userType: "0", documentType: "RUT", documentNumber: "123123123", email: "jose.gonzalez@kushkipagos.com", paymentDescription: "Test JD") { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 10) { error in
            XCTAssertEqual(self.tokenLength, self.transaction!.token.count)
            XCTAssertTrue(self.transaction!.isSuccessful())
        }
    }
    
    func testReturnListBank(){
        var returnedBankList: [Bank] = []
        let asyncExpectation = expectation(description: "requestBankList")
        self.kushkiTransferSubscription!.getBankList(){
            kushkiReturnedBankList in
            returnedBankList = kushkiReturnedBankList
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertTrue(returnedBankList.count > 0)
            
        }
        
    }
    
    func testRequestSubscriptionTransferToken(){
        let asyncExpectation = expectation(description: "request subscription transfer token")
        kushkiTransferSubscription!.requestTransferSubscriptionToken(accountType: "01",accountNumber: "123123123",documentType: "CC",documentNumber: "12312312",totalAmount: 123,bankCode: "1",name: "david1 david2",lastname: "Morales ed",cityCode: "1233",stateCode: "1233",phone: "0989412902",expeditionDate: "12/12/2019",cuestionaryCode: "12", email: "test@test", currency: "USD") { returnedTransaction in
            self.transaction = returnedTransaction
            print(returnedTransaction)
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertTrue(self.transaction!.isSuccessful())
            XCTAssertNotNil(self.transaction!.secureId!)
            XCTAssertNotNil(self.transaction!.secureService!)
            XCTAssertNotNil(self.transaction!.biometricInfo!)
        }
    }
}
