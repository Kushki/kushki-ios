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
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
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
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "",secureService: "")
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
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "",secureService: "")
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
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
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
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
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
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
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
    
    private func buildRequestMessageSubscriptionTransfer(withAccountType accountType: String, withAccountNumber accountNumber: String,
                         withIdentificationType identificationType: String, withIdentificationNumber identificationNumber: String,
                         withTotalAmount totalAmount: Double, withBankCode bankCode: String,
                         withName name: String, withLastName lastName: String, withCityCode cityCode: String,
                         withStateCode stateCode:String, withPhone phone: String, withExpeditionDate expeditionDate: String,
                         withCuestionaryCode cuestionaryCode:String) -> String {
        let requestDictionary:[String: Any] = [
            "accountType": accountType,
            "accountNumber": accountNumber,
            "identificationType": identificationType,
            "identificationNumber": identificationNumber,
            "totalAmount": totalAmount,
            "bankCode": bankCode,
            "name": name,
            "lastName": lastName,
            "cityCode": cityCode,
            "stateCode": stateCode,
            "phone": phone,
            "expeditionDate": expeditionDate,
            "cuestionaryCode": cuestionaryCode
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
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
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
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
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
        
        let kushki = Kushki(publicMerchantId: "20000000107468104000",
                            currency: "COP",
                            environment: KushkiEnvironment.testing_ci,
                            regional: false)
        
        _ = stub(condition: isHost("api-ci.kushkipagos.com")
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
    
    func testGetTokenTransferSubscription(){
        let asyncExpectation = expectation(description: "Get token subscription transfer")
        let expectedSecureId = "12345678"
        let expectedSecureService = "Test secure service"
        
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        _ = stub(condition: isHost("api-uat.kushkipagos.com")
            && isPath("/transfer-subscriptions/v1/tokens")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                _ = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                //XCTAssertEqual(expectedRequestBody.sorted(), requestBody?.sorted())
                let responseBody: [String: Any] = [
                    "token": "12lkj3b1o2kj",
                    "secureId": "12345678",
                    "secureService":"Test secure service"
                ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
        
        kushki.requestTransferSubscriptionToken(accountNumber: "4242424242424242424", accountType: "0", bankCode: "01", documentNumber: "171223344556",  documentType: "CC", email: "test@test", lastname: "Test lastname", name: "Test Name", totalAmount: 10.0) {
            returnedTransaction in
            transaction = returnedTransaction
            
            asyncExpectation.fulfill()
        }
       self.waitForExpectations(timeout: 1) { error in
            XCTAssertTrue(transaction.isSuccessful())
            XCTAssertEqual(expectedSecureId, transaction.secureId)
            XCTAssertEqual(expectedSecureService, transaction.secureService)
        
        }
    }
    
    func testGetSecureValidateQuestionsTransferSubscription(){
        let asyncExpectation = expectation(description: "Get Secure Validate Questions Transfer Subscription")
        
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        _ = stub(condition: isHost("api-uat.kushkipagos.com")
            && isPath("/rules/v1/secureValidation")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                _ = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                let responseBody: [String: Any] = [
                    "code": "BIO010",
                    "message": "Por favor, complete las preguntas",
                    "questionnaireCode": "2",
                    "questions": [
                    [
                    "text": "DE LOS SIGUIENTES TELEFONOS INDIQUE CON CUAL USTED HA TENIDO O TIENE ALGUN VINCULO",
                    "options": [
                    "516216026",
                    "516217026",
                    "516215016",
                    "NINGUNA DE LAS ANTERIORES"
                    ],
                    "id": "1"
                    ],
                    [
                    "text": "EN JULIO DE 2019 SU CUENTA CORRIENTE CON 'BCO POPULAR' ",
                    "options": [
                    "ESTABA ABIERTA/VIGENTE",
                    "ESTABA CANCELADA/SALDADA/CERRADA",
                    "NUNCA HE TENIDO CUENTA CORRIENTE CON LA ENTIDAD"
                    ],
                    "id": "2"
                    ],
                    [
                    "text": "A JULIO DE 2019 EL SALDO DE SU CREDITO HIPOTECARIO CON 'BANCO AV VILLAS (AHORRAMAS)' ESTABA ENTRE",
                    "options": [
                    "$144723001-$202612000",
                    "202612001-$260501000",
                    "$260501001-$318390000",
                    "$318390001-$376279000",
                    "$376279001-$434168000",
                    "NO TENGO CREDITO HIPOTECARIO CON LA ENTIDAD"
                    ],
                    "id": "3"
                    ]
                    ]
                ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        
        var confrontaQuestionnarie = ConfrontaResponse(code: "", message: "", questionnarieCode: "", questions: [])
        kushki.requestSecureValidation(cityCode: "1", expeditionDate:"12/02/2019", phone: "0987654321", secureService: "", secureServiceId: "9b0bfa2d-503c-4075-a04d-58278c7e8ac6" , stateCode: "1") {
            returnedConfrontaQuestionnarie in
            confrontaQuestionnarie = returnedConfrontaQuestionnarie
            asyncExpectation.fulfill()
       }
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(confrontaQuestionnarie.questions)
        }
        
    }
    
    func testGetSecureValidateAnswersQuestionsTransferSubscription(){
        let asyncExpectation = expectation(description: "Get Secure Validate Answers to Questions Transfer Subscription")
        
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "USD",
                            environment: KushkiEnvironment.testing)
        _ = stub(condition: isHost("api-uat.kushkipagos.com")
            && isPath("/rules/v1/secureValidation")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                _ = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                let responseBody: [String: Any] = ["code": "OK", "message": "All right!" ]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        var questionsOptions: ConfrontaQuestionOptions = ConfrontaQuestionOptions(text: "", id: "")
        var questionnarie: ConfrontaQuestionnarie = ConfrontaQuestionnarie(id: "", text: "", options: [questionsOptions])
        var responseSecureValidation: ConfrontaResponse = ConfrontaResponse(code: "", message: "", questionnarieCode: "", questions: [questionnarie] )
        kushki.requestSecureValidation(answers: [["id": "id", "answer": "1"],["id": "id","answer":"2"],["id": "id","answer": "3"]], questionnarieCode: "2", secureService: "1", secureServiceId: "123456789") {
            returnedBiometricInfoResponse in
            responseSecureValidation = returnedBiometricInfoResponse
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 1) { error in
            XCTAssertTrue(responseSecureValidation.code == "OK")
            XCTAssertTrue(responseSecureValidation.message == "All right!")
        }
        
    }
    
    func testGetCashToken(){
        let asyncExpectation = expectation(description: "Get cash token with valid params")
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "MXN",
                            environment: KushkiEnvironment.testing)
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
        _ = stub(condition: isHost("api-uat.kushkipagos.com")
            && isPath("/cash/v1/tokens")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                _ = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                let responseBody: [String: Any] = ["token": "12345"]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        
        kushki.requestCashToken(name: "Test name", lastName: "Test lastname", identification: "123456789", totalAmount: 12.12, email: "test@test.com"){
            returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5){ error in
            XCTAssertNotNil(transaction.token)
            XCTAssertEqual(transaction.token, "12345")
        }
    }
    
    func testGetCashTokenWithInvalidParams(){
        let asyncExpectation = expectation(description: "Get cash token with invalid params")
        let kushki = Kushki(publicMerchantId: publicMerchantId!,
                            currency: "MXN",
                            environment: KushkiEnvironment.testing)
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
        _ = stub(condition: isHost("api-uat.kushkipagos.com")
            && isPath("/cash/v1/tokens")
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                _ = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                let responseBody: [String: Any] = ["code": "K001", "message": "Cuerpo de petición inválido"]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        
        kushki.requestCashToken(name: "Test name", lastName: "", identification: "123456789", totalAmount: 12.12, email: "test@test.com"){
            returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5){ error in
            XCTAssertNotNil(transaction.code)
            XCTAssertNotNil(transaction.message)
            XCTAssertEqual(transaction.code, "K001")
        }
    }
    
    func testGetCardAsyncToken(){
        let asyncExpectation = expectation(description: "Get card async token")
        let kushki = Kushki(publicMerchantId: merchants.ciMerchantIdCLP.rawValue,
                            currency: "CLP",
                            environment: KushkiEnvironment.testing_ci)
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
        _ = stub(condition: isHost(host.hostCI.rawValue)
            && isPath(EndPoint.cardAsyncToken.rawValue)
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                _ = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                let responseBody: [String: Any] = ["token": "123456"]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        kushki.requestCardAsyncToken(description: "test", email: "test@test.com", returnUrl: "www.test.com", totalAmount: 100 ){
            returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5){ error in
            XCTAssertNotNil(transaction.token)
            XCTAssertEqual(transaction.token, "123456")
        }
        
    }
    
    func testGetSubscriptionCardAsyncToken(){
        let asyncExpectation = expectation(description: "Get subscription card async token")
        let kushki = Kushki(publicMerchantId: merchants.ciMerchantIdCLP.rawValue,
                            currency: "CLP",
                            environment: KushkiEnvironment.testing_ci)
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
        _ = stub(condition: isHost(host.hostCI.rawValue)
            && isPath(EndPoint.subscriptionCardAsyncToken.rawValue)
            && isMethodPOST()) { request in
                let nsUrlRequest = request as NSURLRequest
                _ = String(data: nsUrlRequest.ohhttpStubs_HTTPBody(), encoding: .utf8)
                let responseBody: [String: Any] = ["token": "123456"]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        kushki.requestSubscriptionCardAsyncToken(email: "test@test.com", callbackUrl: "www.test.com", cardNumber: "42424242424242424"){
            returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5){ error in
            XCTAssertNotNil(transaction.token)
            XCTAssertEqual(transaction.token, "123456")
        }
    }
    
    func testGetCardInfo(){
        let asyncExpectation = expectation(description: "Get card info")
        let kushki = Kushki(publicMerchantId: "10000002036955013614148494909956",
                            currency: "USD",
                            environment: KushkiEnvironment.testing_ci)
        let bin = "465775"
        var cardInfo = CardInfo(bank: "", brand: "", cardType: "")
        _ = stub(condition: isHost(host.hostCI.rawValue)
            && isPath(EndPoint.cardInfo.rawValue+bin)
            && isMethodGET()) { request in
                _ = request as NSURLRequest
                let responseBody: [String: Any] = ["bank": "BANCO INTERNACIONAL S.A.",
                                                   "brand": "VISA",
                                                   "cardType": "credit"]
                return OHHTTPStubsResponse(jsonObject: responseBody, statusCode: 200, headers: nil)
        }
        
        kushki.getCardInfo(cardNumber: "4657754242424242"){
            returnedCardInfo in
            cardInfo = returnedCardInfo
            print(returnedCardInfo)
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5){
            error in
            XCTAssertNotEqual(cardInfo.bank, "")
            XCTAssertEqual(cardInfo.bank, "BANCO INTERNACIONAL S.A.")
        }
    }

}

public enum merchants: String{
    // Merchants CLP
    //Merchant in CI
    case ciMerchantIdCLP = "20000000106145247000"
    //Merchant in QA
    case qaMerchantIdCLP = "20000000103098876000"
    //Merchant in UAT
    case uatMerchantIdCLP = "10000002667885476032150186346335"
}

public enum host: String{
    case hostCI = "api-ci.kushkipagos.com"
    case hostQA = "api-qa.kushkipagos.com"
    case hostUAT = "api-uat.kushkipagos.com"
}

