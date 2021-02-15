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
    let timeOutTest = 20;
    var publicMerchantId: String?
    var kushki: Kushki?
    var kushkiTransfer:Kushki?
    var kushkiTransferSubscriptionCI: Kushki?
    var kushkiTransferSubscriptionQA: Kushki?
    var kushkiTransferSubscriptionUAT: Kushki?
    var totalAmount: Double?
    var transaction: Transaction?
    

    override func setUp() {
        super.setUp()
        publicMerchantId = "10000001641125237535111218"
        totalAmount = 1.0
        kushki = Kushki(publicMerchantId: publicMerchantId!, currency: "USD", environment: KushkiEnvironment.testing)
        kushkiTransfer = Kushki(publicMerchantId: publicMerchantId!, currency: "CLP", environment: KushkiEnvironment.testing)
        kushkiTransferSubscriptionCI = Kushki(publicMerchantId: "20000000107468104000", currency: "COP", environment: KushkiEnvironment.testing_ci)
        kushkiTransferSubscriptionQA = Kushki(publicMerchantId: "20000000102183993333", currency: "COP", environment: KushkiEnvironment.testing_qa)
        kushkiTransferSubscriptionUAT = Kushki(publicMerchantId: "20000000107415376000", currency: "COP", environment: KushkiEnvironment.testing)
        transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
        
    }

    func testReturnsTokenWhenCalledWithValidParams() {
        let asyncExpectation = expectation(description: "requestToken")
        //let card = Card(name: "John Doe", number: "4242424242424242", cvv: "123", expiryMonth: "12", expiryYear: "21")
        let card2 = Card(name: "Bryan", number: "5300548430205306", cvv: "123", expiryMonth: "12", expiryYear: "21", months: 2, isDeferred: true)
        kushki!.requestToken(card: card2, totalAmount: totalAmount!) { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
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
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
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
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
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
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
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
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
            XCTAssertEqual(self.tokenLength, self.transaction!.token.count)
            XCTAssertTrue(self.transaction!.isSuccessful())
        }
    }
    
    func testReturnsSubscriptionTokenWhenCalledWithInvalidParams() {
        let asyncExpectation = expectation(description: "requestSubscriptionToken")
        let card = Card(name: "John Doe", number: "", cvv: "123", expiryMonth: "12", expiryYear: "21")
        kushki!.requestSubscriptionToken(card: card) { returnedTransaction in
            self.transaction = returnedTransaction
            print("resp: " + returnedTransaction.code)
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
            XCTAssertEqual(self.transaction!.token, "")
            XCTAssertFalse(self.transaction!.isSuccessful())
            XCTAssertEqual(self.transaction!.code, "K001")
            XCTAssertEqual(self.transaction!.message, "Cuerpo de la petición inválido.")
        }
    }
    
    func testReturnsTransferTokenWhenCalledWithValidParams() {
        let asyncExpectation = expectation(description: "requestTransferToken")
        let amount = Amount(subtotalIva: 12.0, subtotalIva0: 0.0, iva: 1.2 )

        kushkiTransfer!.requestTransferToken(amount: amount, callbackUrl: "www.test.com", userType: "0", documentType: "RUT", documentNumber: "123123123", email: "jose.gonzalez@kushkipagos.com") { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout:TimeInterval(timeOutTest)) { error in
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
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
            XCTAssertEqual(self.tokenLength, self.transaction!.token.count)
            XCTAssertTrue(self.transaction!.isSuccessful())
        }
    }
    
    func testReturnListBank(){
        var returnedBankList: [Bank] = []
        let asyncExpectation = expectation(description: "requestBankList")
        self.kushkiTransferSubscriptionUAT!.getBankList(){
            kushkiReturnedBankList in
            returnedBankList = kushkiReturnedBankList
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
            XCTAssertTrue(returnedBankList.count > 0)
            
        }
        
    }
    
    func testRequestSubscriptionTransferToken(){
        let asyncExpectation = expectation(description: "request subscription transfer token")
    kushkiTransferSubscriptionUAT!.requestTransferSubscriptionToken(accountNumber: "123123123", accountType: "01", bankCode: "1", documentNumber: "12312312", documentType: "CC", email: "test@test", lastname: "Morales ed", name: "david1 david2", totalAmount: 123) { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
            XCTAssertTrue(self.transaction!.isSuccessful())
            XCTAssertNotNil(self.transaction!.secureId!)
            XCTAssertNotNil(self.transaction!.secureService!)
        }
    }
    
    func testRequestSubscriptionFailedTransferToken(){
        let asyncExpectation = expectation(description: "request subscription transfer token")
        kushkiTransferSubscriptionUAT!.requestTransferSubscriptionToken(accountNumber: "123123123", accountType: "01", bankCode: "123",documentNumber: "12312312", documentType: "CC", email: "test@test", lastname: "Morales ed", name: "david1 david2", totalAmount: 123) { returnedTransaction in
            self.transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
            XCTAssertFalse(self.transaction!.isSuccessful())
            XCTAssertEqual(self.transaction?.code, "TS014")
            XCTAssertEqual(self.transaction?.message,"Banco no encontrado" )
        }
    }
    
    func testRequestSecureValidationConfrontaWhenSecureIdIsInvalid() {
        let asyncExpectationToken = expectation(description: "request transfer subscription secure validation token")
        let asyncExpectationQuestion = expectation(description: "request transfer subscription secure validation questionary")
        var code = ""
        var message = ""
        kushkiTransferSubscriptionUAT!.requestTransferSubscriptionToken(accountNumber: "123123123", accountType: "01", bankCode: "1", documentNumber: "892352", documentType: "CC", email: "test@test.com", lastname: "Lema", name: "TOBAR", totalAmount: 25.0){
            returnedTransaction in
            XCTAssertNotEqual(returnedTransaction.token, "")
            XCTAssertEqual(returnedTransaction.code, "000")
            asyncExpectationToken.fulfill();
        }
        wait(for: [asyncExpectationToken], timeout: 10)
        kushkiTransferSubscriptionUAT!.requestSecureValidation(cityCode: "1", expeditionDate: "2019-01-01", phone: "0987654321", secureService: "InvalidsecureId", secureServiceId: "InvalidSecureId", stateCode: "1"){
            returnedConfrontaQuestionarie in
            code = returnedConfrontaQuestionarie.code
            message = returnedConfrontaQuestionarie.message
            XCTAssertEqual(returnedConfrontaQuestionarie.questionnarieCode, "")
            asyncExpectationQuestion.fulfill()
        }
        
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
            XCTAssertEqual(code, "CardRule Credential not found")
            XCTAssertEqual(message, "El ID de comercio no corresponde a la credencial enviada")
        }
        
    }
    
    func testRequestSecureValidationConfrontaSuccessQuestions(){
        let asyncExpectationToken = expectation(description: "request transfer subscription secure validation token")
        let asyncExpectationQuestion = expectation(description: "request transfer subscription secure validation questionary")
        var questionnarieCode: String = ""
        var code: String = ""
        var message: String = ""
        var secureServiceId = ""
        var secureService = ""
        kushkiTransferSubscriptionUAT!.requestTransferSubscriptionToken(accountNumber: "123123123", accountType: "01", bankCode: "1", documentNumber: "892352", documentType: "CC", email: "test@test.com", lastname: "Lema", name: "TOBAR", totalAmount: 25.0){
            returnedTransaction in
            secureServiceId = returnedTransaction.secureId ?? ""
            secureService = returnedTransaction.secureService ?? ""
            XCTAssertNotEqual(returnedTransaction.token, "")
            XCTAssertEqual(returnedTransaction.code, "000")
            asyncExpectationToken.fulfill();
        }
        
        wait(for: [asyncExpectationToken], timeout: 10)
        
        kushkiTransferSubscriptionUAT!.requestSecureValidation(cityCode: "1", expeditionDate: "2019-01-01", phone: "0987654321", secureService: secureService, secureServiceId: secureServiceId, stateCode: "1"){
            returnedConfrontaQuestionarie in
            questionnarieCode = returnedConfrontaQuestionarie.questionnarieCode
            code = returnedConfrontaQuestionarie.code
            message = returnedConfrontaQuestionarie.message
            XCTAssertNotEqual(returnedConfrontaQuestionarie.questionnarieCode, "")
            asyncExpectationQuestion.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
            XCTAssertTrue(questionnarieCode != "")
            XCTAssertEqual(code, "BIO010")
            XCTAssertEqual(message,"Por favor, complete las preguntas pendientes")
        }
        
    }
    
    func testRequestSecureValidationConfrontaFlowCompletedSuccess(){
        let asyncExpectationToken = expectation(description: "request transfer subscription secure validation token")
        let asyncExpectationQuestion = expectation(description: "request transfer subscription secure validation questionary")
        let asyncExpectationAnswer = expectation(description: "request transfer subscription secure validation answer")
        var questionnarieCode: String = ""
        var code: String = ""
        var message: String = ""
        var secureServiceId = ""
        var secureService = ""
        var answers: [[String: String]] = []
        kushkiTransferSubscriptionUAT!.requestTransferSubscriptionToken(accountNumber: "123123123", accountType: "01", bankCode: "1", documentNumber: "892352", documentType: "CC", email: "test@test.com", lastname: "Lema", name: "TOBAR", totalAmount: 25.0){
            returnedTransaction in
            secureServiceId = returnedTransaction.secureId ?? ""
            secureService = returnedTransaction.secureService ?? ""
            XCTAssertNotEqual(returnedTransaction.token, "")
            XCTAssertEqual(returnedTransaction.code, "000")
            asyncExpectationToken.fulfill();
        }
        
        wait(for: [asyncExpectationToken], timeout: 10)
        
        kushkiTransferSubscriptionUAT!.requestSecureValidation(cityCode: "1", expeditionDate: "2019-01-01", phone: "0987654321", secureService: secureService, secureServiceId: secureServiceId, stateCode: "1"){
            returnedConfrontaQuestionarie in
            questionnarieCode = returnedConfrontaQuestionarie.questionnarieCode
            answers = [
                [
                    "id": "1",
                    "answer": "1"
                ],
                [
                    "id": "2",
                    "answer": "1"
                ],
                [
                    "id": "3",
                    "answer": "1"
                ],
                [
                    "id": "4",
                    "answer": "1"
                ]
            ]
            XCTAssertNotEqual(returnedConfrontaQuestionarie.questionnarieCode, "")
            asyncExpectationQuestion.fulfill()
        }
        
        wait(for: [asyncExpectationQuestion], timeout: 10)

        kushkiTransferSubscriptionUAT!.requestSecureValidation(answers: answers, questionnarieCode: questionnarieCode, secureService: secureService, secureServiceId: secureServiceId){
            returnedInfo in
            code = returnedInfo.code
            message = returnedInfo.message
            asyncExpectationAnswer.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
            XCTAssertTrue(questionnarieCode != "")
            XCTAssertEqual(code, "BIO000")
            XCTAssertEqual(message, "ok")
        }
        
    }
    
    func testRequestFailSecureValidationConfronta(){
        let asyncExpectationToken = expectation(description: "request transfer subscription secure validation token")
        let asyncExpectationQuestion = expectation(description: "request transfer subscription secure validation questionary")
        let asyncExpectationAnswer = expectation(description: "request transfer subscription secure validation answer")
        var questionnarieCode: String = ""
        var code: String = ""
        var message: String = ""
        var secureServiceId = ""
        var secureService = ""
        var answers: [[String: String]] = []
        kushkiTransferSubscriptionUAT!.requestTransferSubscriptionToken(accountNumber: "123123123", accountType: "01", bankCode: "1", documentNumber: "892352", documentType: "CC", email: "test@test.com", lastname: "Lema", name: "TOBAR", totalAmount: 25.0){
            returnedTransaction in
            secureServiceId = returnedTransaction.secureId ?? ""
            secureService = returnedTransaction.secureService ?? ""
            XCTAssertNotEqual(returnedTransaction.token, "")
            XCTAssertEqual(returnedTransaction.code, "000")
            asyncExpectationToken.fulfill();
        }
        
        wait(for: [asyncExpectationToken], timeout: 10)
        
        kushkiTransferSubscriptionUAT!.requestSecureValidation(cityCode: "1", expeditionDate: "2019-01-01", phone: "0987654321", secureService: secureService, secureServiceId: secureServiceId, stateCode: "1"){
            returnedConfrontaQuestionarie in
            questionnarieCode = returnedConfrontaQuestionarie.questionnarieCode
            answers = [
                [
                    "id": "1",
                    "answer": "1"
                ],
                [
                    "id": "2",
                    "answer": "1"
                ],
                [
                    "id": "3",
                    "answer": "1"
                ],
                [
                    "id": "4",
                    "answer": "1"
                ]
            ]
            XCTAssertNotEqual(returnedConfrontaQuestionarie.questionnarieCode, "")
            asyncExpectationQuestion.fulfill()
        }
        
        wait(for: [asyncExpectationQuestion], timeout: 10)

        kushkiTransferSubscriptionUAT!.requestSecureValidation(answers: answers, questionnarieCode: questionnarieCode, secureService: secureService, secureServiceId: secureServiceId){
            returnedInfo in
            code = returnedInfo.code
            message = returnedInfo.message
            asyncExpectationAnswer.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)) { error in
            XCTAssertTrue(questionnarieCode != "")
            XCTAssertTrue(code != "BIO100")
            XCTAssertTrue(message != "Invalid user")
        }
    }
    
    func testRequestCashToken(){
        let asyncExpectation = expectation(description: "Get cash token with valid params")
        let kushki = Kushki(publicMerchantId: "20000000100743782000",
                            currency: "COP",
                            environment: KushkiEnvironment.testing_qa)
         var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
        kushki.requestCashToken(name: "Test name", lastName: "Test lastname", identification: "123456789", totalAmount: 12.12, email: "test@test.com"){
            returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)){ error in
            XCTAssertNotEqual(transaction.token, "wwwwww")
        }
    }
    
    func testRequestCashTokenWithInvalidParams(){
        let asyncExpectation = expectation(description: "Get cash token with invalid params")
        let kushki = Kushki(publicMerchantId: "20000000100743782000",
                            currency: "COP",
                            environment: KushkiEnvironment.testing_qa)
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
        kushki.requestCashToken(name: "", lastName: "", identification: "", totalAmount: -1, email: ""){
            returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)){ error in
            XCTAssertEqual(transaction.token, "")
            XCTAssertEqual(transaction.code, "C001")
            XCTAssertEqual(transaction.message, "Cuerpo de la petición inválido.")
        }
    }
    
    func testGetCardAsyncTokenWithoutDescription(){
        let asyncExpectation = expectation(description: "Get card async token")
        let kushki = Kushki(publicMerchantId: merchants.ciMerchantIdCLP.rawValue,
                            currency: "CLP",
                            environment: KushkiEnvironment.testing_ci)
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
       
        kushki.requestCardAsyncToken( returnUrl: "www.test.com", totalAmount: 100 ){
            returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)){ error in
            XCTAssertNotNil(transaction.token)
        }
    }
    
    func testGetCardAsyncTokenWithDescription(){
        let asyncExpectation = expectation(description: "Get card async token")
        let kushki = Kushki(publicMerchantId: merchants.ciMerchantIdCLP.rawValue,
                            currency: "CLP",
                            environment: KushkiEnvironment.testing_ci)
        var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
       
        kushki.requestCardAsyncToken(description: "Test", email: "test@test.com", returnUrl: "www.test.com", totalAmount: 100 ){
            returnedTransaction in
            transaction = returnedTransaction
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)){ error in
            XCTAssertNotNil(transaction.token)
        }
    }
    
    func testGetSubscriptionCardAsyncTokenWithOptionalParams(){
       let asyncExpectation = expectation(description: "Get subscription card async token")
       let kushki = Kushki(publicMerchantId: merchants.uatMerchantIdCLP.rawValue,
                           currency: "CLP",
                           environment: KushkiEnvironment.testing)
       var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
      
       kushki.requestSubscriptionCardAsyncToken(email: "test@test.com", callbackUrl: "https://www.test.com", cardNumber: "42424242424242424"){
           returnedTransaction in
           transaction = returnedTransaction
           asyncExpectation.fulfill()
       }
       self.waitForExpectations(timeout: TimeInterval(timeOutTest)){ error in
        XCTAssertNotEqual(transaction.token, "")
       }
    }
    
    func testGetSubscriptionCardAsyncTokenWithoutOptionalParams(){
       let asyncExpectation = expectation(description: "Get subscription card async token")
       let kushki = Kushki(publicMerchantId: merchants.uatMerchantIdCLP.rawValue,
                           currency: "CLP",
                           environment: KushkiEnvironment.testing)
       var transaction = Transaction(code: "", message: "", token: "", settlement: nil, secureId: "", secureService: "")
      
       kushki.requestSubscriptionCardAsyncToken(email: "test@test.com", callbackUrl: "https://www.test.com"){
           returnedTransaction in
           transaction = returnedTransaction
           asyncExpectation.fulfill()
       }
       self.waitForExpectations(timeout: TimeInterval(timeOutTest)){ error in
           XCTAssertEqual(transaction.token, "")
           XCTAssertEqual(transaction.code, "K001")
           XCTAssertEqual(transaction.message, "Cuerpo de la petición inválido.")
       }
    }
    
    func testGetCardInfo(){
        let asyncExpectation = expectation(description: "Get card info")
        let kushki = Kushki(publicMerchantId: "10000002036955013614148494909956",
                            currency: "USD",
                            environment: KushkiEnvironment.testing_qa)
        var cardInfo = CardInfo(bank: "", brand: "", cardType: "")
        kushki.getCardInfo(cardNumber: "4657758223843047"){
            returnedCardInfo in
            cardInfo = returnedCardInfo
            asyncExpectation.fulfill()
        }
        self.waitForExpectations(timeout: TimeInterval(timeOutTest)){
            error in
            XCTAssertNotEqual(cardInfo.bank, "")
            XCTAssertEqual(cardInfo.bank, "BANCO INTERNACIONAL S.A.")
        }
    }
}
