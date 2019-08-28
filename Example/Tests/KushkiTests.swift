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
        let expectedToken = Helpers.randomAlphanumeric(32)
        let expectedRequestMessage = buildRequestMessage(withMerchantId: publicMerchantId!, withCard: card, withAmount: totalAmount!, withCurrency: "USD")
        let expectedRequestBody = expectedRequestMessage
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        _ = stub(condition: isHost("api-uat.kushkipagos.com")
            && isPath("/v1/tokens")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                let requestBody = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                XCTAssertEqual(expectedRequestBody.sorted(), requestBody?.sorted())
                let responseBody = [
                    "token": expectedToken
                ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil)
        kushki.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(expectedToken, transaction.token)            
            XCTAssertNil(transaction.settlement)
            XCTAssertTrue(transaction.isSuccessful())
        }
    }
    
    func testReturnsSubscriptionTokenWhenCalledWithValidParams() {
        let asyncExpectation = expectation(description: "requestSubscriptionToken")
        let card = Card(name: "John Doe", number: "4242424242424242", cvv: "123", expiryMonth: "12", expiryYear: "21")
        let expectedToken = Helpers.randomAlphanumeric(32)
        let expectedRequestMessage = buildRequestMessageWithoutAmount(withMerchantId: publicMerchantId!, withCard: card, withCurrency: "USD")
        let expectedRequestBody = expectedRequestMessage
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        _ = stub(condition: isHost("api-uat.kushkipagos.com")
            && isPath("/v1/subscription-tokens")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                let requestBody = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                XCTAssertEqual(expectedRequestBody.sorted(), requestBody?.sorted())
                let responseBody = [
                    "token": expectedToken
                ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil)
        kushki.requestSubscriptionToken(card: card) { returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(expectedToken, transaction.token)
            XCTAssertTrue(transaction.isSuccessful())
        }
    }
    
    func testReturnsTransferTokenWhenCalledWithValidParams() {
        let asyncExpectation = expectation(description: "requestTransferToken")
        let amount = Amount(subtotalIva: 12.0, subtotalIva0: 0.0, iva: 1.2 )
        let expectedToken = Helpers.randomAlphanumeric(32)
        let expectedRequestMessage = buildRequestMessageTransfer(withMerchantId: publicMerchantId!, withAmount: amount, withCallbackUrl: "www.test.com", withUserType: "0", withDocumentType: "CC", withDocumentNumber: "123123123", withEmail: "dev@kushkipagos.com", withCurrency: "CLP")
        let expectedRequestBody = expectedRequestMessage
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "CLP",
                            environment: KushkiEnvironment.testing)
        _ = stub(condition: isHost("api-uat.kushkipagos.com")
            && isPath("/transfer/v1/tokens")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                let requestBody = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
              XCTAssertEqual(expectedRequestBody.sorted(), requestBody?.sorted())
                let responseBody = [
                    "token": expectedToken
                ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil)
        kushki.requestTransferToken(amount: amount, callbackUrl: "www.test.com", userType: "0", documentType:"CC", documentNumber: "123123123", email: "dev@kushkipagos.com") { returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(expectedToken, transaction.token)
            XCTAssertTrue(transaction.isSuccessful())
        }
    }
    
    func testReturnsTransferTokenWhenCalledWithValidAndCompleteParams() {
        let asyncExpectation = expectation(description: "requestTransferToken")
        let amount = Amount(subtotalIva: 12.0, subtotalIva0: 0.0, iva: 1.2 )
        let expectedToken = Helpers.randomAlphanumeric(32)
        let expectedRequestMessage = buildRequestMessageTransferWithCompleteParameters(withMerchantId: publicMerchantId!, withAmount: amount, withCallbackUrl: "www.test.com", withUserType: "0", withDocumentType: "CC", withDocumentNumber: "123123123", withEmail: "dev@kushkipagos.com", withCurrency: "CLP",withPaymentDescription:"Test JD")
        let expectedRequestBody = expectedRequestMessage
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "CLP",
                            environment: KushkiEnvironment.testing)
        _ = stub(condition: isHost("api-uat.kushkipagos.com")
            && isPath("/transfer/v1/tokens")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                let requestBody = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                XCTAssertEqual(expectedRequestBody.sorted(), requestBody?.sorted())
                let responseBody = [
                    "token": expectedToken
                ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil)
        kushki.requestTransferToken(amount: amount, callbackUrl: "www.test.com", userType: "0", documentType:"CC", documentNumber: "123123123", email: "dev@kushkipagos.com",paymentDescription:"Test JD") { returnedTransaction in
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
        let expectedRequestMessage = buildRequestMessage(withMerchantId: publicMerchantId!, withCard: card, withAmount: totalAmount!, withCurrency: "USD")
        let expectedRequestBody = expectedRequestMessage
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        _ = stub(condition: isHost("api-uat.kushkipagos.com")
            && isPath("/v1/tokens")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                let requestBody = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                XCTAssertEqual(expectedRequestBody.sorted(), requestBody!.sorted())
                let responseBody = [
                    "code": "017",
                    "message": "Tarjeta no válida"
                ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 402, headers: nil)
        }
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil)
        kushki.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertEqual("017", transaction.code)
            XCTAssertEqual("Tarjeta no válida", transaction.message)
            XCTAssertEqual("", transaction.token)
            XCTAssertFalse(transaction.isSuccessful())
        }
    }
    
    func testWithRegionalEndpoint() {
        let asyncExpectation = expectation(description: "requestToken")
        let card = Card(name: "John Doe", number: "4242424242424242", cvv: "123", expiryMonth: "12", expiryYear: "21")
        let expectedToken = Helpers.randomAlphanumeric(32)
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "USD",
                            environment: KushkiEnvironment.testing,
                            regional: true)
        _ = stub(condition: isHost("regional-uat.kushkipagos.com")
            && isPath("/v1/tokens")
            && isMethodPOST()) { _ in
                let responseBody = [
                    "token": expectedToken
                ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil)
        kushki.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(expectedToken, transaction.token)
            XCTAssertTrue(transaction.isSuccessful())
        }
    }
    
    
    private func buildRequestMessage(withMerchantId publicMerchantId: String, withCard card: Card, withAmount totalAmount: Double, withCurrency currency: String) -> String {
        let requestDictionary:[String : Any] = [
            "card": [
                "name": card.name,
                "number": card.number,
                "expiryMonth": card.expiryMonth,
                "expiryYear": card.expiryYear,
                "cvv": card.cvv
            ],
            "totalAmount": totalAmount,
            "currency": currency
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.ascii)
        return dictFromJson!
    }
    
    private func buildRequestMessage(withMerchantId publicMerchantId: String, withCard card: Card, withAmount totalAmount: Double, withCurrency currency: String, withMonths months: Int) -> String {
        let requestDictionary:[String : Any] = [
            "card": [
                "name": card.name,
                "number": card.number,
                "expiryMonth": card.expiryMonth,
                "expiryYear": card.expiryYear,
                "cvv": card.cvv
            ],
            "months": months,
            "totalAmount": totalAmount,
            "currency": currency
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.ascii)
        return dictFromJson!
    }
    
    
    
    private func buildRequestMessageWithoutAmount(withMerchantId publicMerchantId: String, withCard card: Card, withCurrency currency: String) -> String {
        let requestDictionary:[String : Any] = [
            "card": [
                "name": card.name,
                "number": card.number,
                "expiryMonth": card.expiryMonth,
                "expiryYear": card.expiryYear,
                "cvv": card.cvv
            ],
            "currency": currency
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.ascii)
        return dictFromJson!
    }
    
    private func buildRequestMessageTransfer(withMerchantId publicMerchantId: String, withAmount amount: Amount, withCallbackUrl callbackUrl:String,  withUserType userType:String,withDocumentType documentType:String,
                                             withDocumentNumber documentNumber:String, withEmail email:String,
                                             withCurrency currency:String) -> String {
        let requestDictionary:[String : Any] = [
            "amount": [
                "subtotalIva": amount.subtotalIva,
                "subtotalIva0": amount.subtotalIva0,
                "iva": amount.iva,
            ],
            "callbackUrl": callbackUrl,
            "userType" : userType,
            "documentType" : documentType,
            "documentNumber" : documentNumber,
            "email" : email,
            "currency" : currency
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.ascii)
        return dictFromJson!
    }
    
    private func buildRequestMessageTransferWithCompleteParameters(withMerchantId publicMerchantId: String, withAmount amount: Amount, withCallbackUrl callbackUrl:String,  withUserType userType:String,withDocumentType documentType:String, withDocumentNumber documentNumber:String, withEmail email:String, withCurrency currency:String, withPaymentDescription paymentDescription:String) -> String {
        let requestDictionary:[String : Any] = [
            "amount": [
                "subtotalIva": amount.subtotalIva,
                "subtotalIva0": amount.subtotalIva0,
                "iva": amount.iva,
            ],
            "callbackUrl": callbackUrl,
            "userType" : userType,
            "documentType" : documentType,
            "documentNumber" : documentNumber,
            "email" : email,
            "currency" : currency,
            "paymentDescription" : paymentDescription
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.ascii)
        return dictFromJson!
    }
    
    
    func testTokensWithSettlement() {
        let asyncExpectation = expectation(description: "requestToken with settlement")
        let months = 3
        let card = Card(name: "John Doe", number: "4242424242424242", cvv: "123", expiryMonth: "12", expiryYear: "21", months: months)
        let expectedRequestMessage = buildRequestMessage(withMerchantId: publicMerchantId!, withCard: card, withAmount: totalAmount!, withCurrency: "USD", withMonths: months)
        let expectedRequestBody = expectedRequestMessage
        let expectedSettlement = 5.0
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        
        _ = stub(condition: isHost("api-uat.kushkipagos.com")
            && isPath("/v1/tokens")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                let requestBody = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                XCTAssertEqual(expectedRequestBody.sorted(), requestBody?.sorted())
                let responseBody: [String: Any] = [
                    "token": "12lkj3b1o2kj",
                    "settlement": expectedSettlement
                ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil)
        kushki.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertTrue(transaction.isSuccessful())
            XCTAssertEqual(expectedSettlement, transaction.settlement)
        }
    }
    
    func testUnexpectedError() {
        let asyncExpectation = expectation(description: "requestToken with settlement")
        let card = Card(name: "Name", number: "123123", cvv: "000", expiryMonth: "01", expiryYear: "31")
        let expectedRequestMessage = buildRequestMessage(withMerchantId: publicMerchantId!, withCard: card, withAmount: totalAmount!, withCurrency: "USD")
        let expectedRequestBody = expectedRequestMessage
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        
        _ = stub(condition: isHost("api-uat.kushkipagos.com")
            && isPath("/v1/tokens")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                let requestBody = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                XCTAssertEqual(expectedRequestBody.sorted(), requestBody?.sorted())
                let responseBody: [String: Any] = [:]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil)
        kushki.requestToken(card: card, totalAmount: totalAmount!) { returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(transaction.message, "Error inesperado")
            
        }
    }
    
    func testGetBankListAuthorizedToken() {
        let asyncExpectation = expectation(description: "Get Bank List")
        let expectedBankList: [Bank] =  [Bank(code:"1", name: "Banco de Bogota" )]
        var returnedBankList: [Bank] = []
        
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "COP",
                            environment: KushkiEnvironment.testing,
                            regional: false)
        
        _ = stub(condition: isHost("api-qa.kushkipagos.com")
            && isPath("/transfer-subscriptions/v1/bankList")
            && isMethodGET()) {
                _ in
                let responseBody = [["name": "Banco de Bogota" , "code": "1" ]]
                 return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
    
        kushki.getBankList(){
            kushkiReturnedBankList in
            returnedBankList = kushkiReturnedBankList
            asyncExpectation.fulfill()
        }
     
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertEqual(returnedBankList[0].name, expectedBankList[0].name)
            
        }
    }
}
