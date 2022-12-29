import Foundation
import Sift
import CardinalMobile

class KushkiClient: CardinalValidationDelegate {

    private let environment: KushkiEnvironment
    private let regional: Bool
    var session : CardinalSession!

    required init(environment: KushkiEnvironment, regional: Bool) {
        self.regional = regional
        self.environment = regional ? environment == KushkiEnvironment.production ? KushkiEnvironment.production_regional : KushkiEnvironment.testing_regional : environment
    }
    
    func post(withMerchantId publicMerchantId: String, endpoint: String, requestMessage: String, withCompletion completion: @escaping (Transaction) -> ()) {
        if(endpoint == EndPoint.token.rawValue) {
            var settings: MerchantSettingsResponse = MerchantSettingsResponse(active3dsecure: false, code: "", message: "",sandboxEnable: false)
            self.requestMerchantSetting(mid: publicMerchantId) { response in
                settings = response
                if(settings.active3dsecure) {
                    let isTest: Bool = self.environment != KushkiEnvironment.production || self.environment != KushkiEnvironment.production_regional
                    self.requestCybersourceFlow(mid: publicMerchantId, isTest: isTest, endpoint: endpoint, requestMessage: requestMessage, isSandboxEnabled: settings.sandboxEnable, completion: completion)
                } else {
                    self.showHttpResponse(withMerchantId: publicMerchantId, endpoint: endpoint, requestBody: requestMessage) { transaction in
                        completion(self.parseResponse(jsonResponse: transaction))
                    }
                }
            }
        } else {
            self.showHttpResponse(withMerchantId: publicMerchantId, endpoint: endpoint, requestBody: requestMessage) { transaction in
                completion(self.parseResponse(jsonResponse: transaction))
            }
        }
    }
    
    func post(withMerchantId publicMerchantId: String, endpoint: String, requestMessage: String, withCompletion completion: @escaping (ConfrontaResponse) -> ()){
        showHttpResponse(withMerchantId: publicMerchantId, endpoint: endpoint, requestBody: requestMessage) { response in
            completion(self.parseValidationResponse(jsonResponse: response))
        }
    }

    func post(withMerchantId publicMerchantId: String, endpoint: String, requestMessage: String, withCompletion completion: @escaping (SecureValidationResponse) -> ()){
        showHttpResponse(withMerchantId: publicMerchantId, endpoint: endpoint, requestBody: requestMessage) { response in
            completion(self.parseSecureValidationResponse(jsonResponse: response))
        }
    }

    func get(withMerchantId publicMerchantId: String, endpoint: String, withCompletion completion: @escaping (MerchantSettingsResponse) -> ()){
        showHttpGetResponse(withMerchantId: publicMerchantId, endpoint: endpoint) { response in
            completion(self.parseSettingsResponse(jsonResponse: response))
        }
    }

    func get(withMerchantId publicMerchantId: String, endpoint: String, withCompletion completion: @escaping ([Bank]) -> ()) {
        showHttpGetResponse(withMerchantId: publicMerchantId, endpoint: endpoint) {
            bankList in
            completion(self.parseGetBankListResponse(jsonResponse: bankList))
        }
    }
    
    func get(withMerchantId publicMerchantId: String, endpoint: String, withParam param: String , withCompletion completion: @escaping (CardInfo) -> ()) {
        showHttpGetResponse(withMerchantId: publicMerchantId, endpoint: endpoint, param: param) {
            cardInfo in
            completion(self.parseGetCardInfoResponse(jsonResponse: cardInfo))
        }
    }
    
    func getMerchantSettings(withMerchantId publicMerchantId: String, endpoint: String, withCompletion completion: @escaping(MerchantSettings) -> ()) {
        showHttpGetMerchantSettings(withMerchantId: publicMerchantId, endpoint: endpoint, withCompletion: completion)
    }

    func initSiftScience(merchantSettings: MerchantSettings, userId: String) {
        let sift = Sift.sharedInstance
        sift()?.accountId = self.environment == KushkiEnvironment.production ? merchantSettings.prodAccountId : merchantSettings.sandboxAccountId
        sift()?.beaconKey = self.environment == KushkiEnvironment.production ? merchantSettings.prodBaconKey : merchantSettings.sandboxBaconKey
        sift()?.userId = userId
        // sift()?.allowUsingMotionSensors = true
    }

    func buildParameters(withCard card: Card, withCurrency currency: String) -> String {
        let requestDictionary = buildJsonObject(withCard: card, withCurrency: currency)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }
    
    func buildParameters(withCard card: Card, withCurrency currency: String, withAmount totalAmount: Double, withSiftScienceResponse siftScienceResponse: SiftScienceObject) -> String {
        let requestDictionary = buildJsonObject(withCard: card, withCurrency: currency, withAmount: totalAmount, siftScienceResponse: siftScienceResponse)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }
    
    func buildParameters(withAmount amount: Amount, withCallbackUrl callbackUrl:String,
                         withUserType userType:String,withDocumentType documentType:String,
                         withDocumentNumber documentNumber:String, withEmail email:String,
                         withCurrency currency:String) -> String {
        let requestDictionary = buildJsonObject(withAmount: amount, withCallbackUrl: callbackUrl,
                                                withUserType: userType,withDocumentType: documentType,
                                                withDocumentNumber: documentNumber, withEmail: email,
                                                withCurrency: currency)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }
    
    func buildParameters(withAmount amount: Amount, withCallbackUrl callbackUrl:String,
                         withUserType userType:String,withDocumentType documentType:String,
                         withDocumentNumber documentNumber:String, withEmail email:String,
                         withCurrency currency:String, withPaymentDescription paymentDescription:String) -> String {
        
        let requestDictionary = buildJsonObject(withAmount: amount, withCallbackUrl: callbackUrl,
                                                withUserType: userType,withDocumentType: documentType,
                                                withDocumentNumber: documentNumber, withEmail: email,
                                                withCurrency: currency,withPaymentDescription: paymentDescription)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }
    
    func buildParameters(
        withAccountNumber accountNumber: String, withAccountType accountType: String, withBankCode bankCode: String, withCurrency currency: String, withDocumentNumber documentNumber: String, withDocumentType documentType: String, withEmail email: String, withLastName lastName: String, withName name: String, withTotalAmount totalAmount: Double) -> String{
        let requestDictionary = buildJsonObject(withAccountNumber: accountNumber, withAccountType: accountType, withBankCode: bankCode, withCurrency: currency , withDocumentNumber: documentNumber, withDocumentType: documentType, withEmail: email, withLastName: lastName, withName: name, withTotalAmount: totalAmount)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }
    
    func buildParameters(
        withCityCode cityCode: String, withExpeditionDate expeditionDate: String, withPhone phone: String, withSecureService secureService: String,withSecureServiceId secureServiceId: String, withStateCode stateCode: String) -> String{
        let requestDictionary = buildJsonObject(withCityCode: cityCode, withExpeditionDate: expeditionDate, withPhone: phone, withSecureService: secureService, withSecureServiceId: secureServiceId, withStateCode: stateCode)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }
    
    func buildParameters(withAnswers answers: [[String: String]], withQuestionnarieCode questionnarieCode: String, withSecureService secureService: String, withSecureServiceId secureServiceId: String) -> String{
        let requestDictionary = buildJsonObject(withAnswers: answers, withQuestionnarieCode: questionnarieCode, withSecureService: secureService, withSecureServiceId: secureServiceId)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }
    
    func buildParameters(withName name : String, withLastName lastName: String, withIdentification identification: String, withTotalAmount totalAmount: Double, withCurrency currency: String, withEmail email: String) -> String{
        let requestDictionary = buildJsonObject(withName: name, withLastName: lastName, withIdentification: identification, withTotalAmount: totalAmount, withCurrency: currency, withEmail: email)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }
    
    func buildParameters(withCurrency currency: String, withDescription description : String, withEmail email: String, withReturnUrl returnUrl: String, withTotalAmount totalAmount: Double) -> String{
        let requestDictionary = buildJsonObject(withCurrency: currency, withDescription: description, withEmail: email, withReturnUrl: returnUrl, withTotalAmount: totalAmount)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }
    
    func buildParameters(withCurrency currency: String, withEmail email: String, withCallbackUrl callbackUrl: String, withCardNumber cardNumber: String) -> String{
        let requestDictionary = buildJsonObject(withCurrency: currency, withEmail: email, withCallbackUrl: callbackUrl, withCardNumber: cardNumber)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }
    
    func buildParameters(withSecureServiceId secureServiceId: String, withOtpValue otpValue: String, withSecureService secureService: String) -> String {
        let requestDictionary = buildJsonObject(withSecureServiceId: secureServiceId, withOtpValue: otpValue, withSecureService: secureService)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }

    func buildParameters(withSecureServiceId secureServiceId: String, withOtpValue otpValue: String) -> String {
        let requestDictionary = buildJsonObject(withSecureServiceId: secureServiceId, withOtpValue: otpValue)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }

    func buildJsonObject(withCard card: Card, withCurrency currency: String) -> [String : Any] {
        
        var requestDictionary:[String : Any] = [
            "card": [
                "name": card.name,
                "number": card.number,
                "expiryMonth": card.expiryMonth,
                "expiryYear": card.expiryYear,
                "cvv": card.cvv
            ],
            "currency": currency
        ]
        
        if card.months != 0 {
            requestDictionary["months"] = card.months
        }
        if card.isDeferred {
            requestDictionary["isDeferred"] = card.isDeferred
        }
        return requestDictionary
    }
    
    func buildJsonObject(withAmount amount: Amount, withCallbackUrl callbackUrl:String,
                         withUserType userType:String,withDocumentType documentType:String,
                         withDocumentNumber documentNumber:String, withEmail email:String,
                         withCurrency currency:String) -> [String : Any]{
        
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
        
        return requestDictionary
        
    }
    
    func buildJsonObject(withAmount amount: Amount, withCallbackUrl callbackUrl:String,
                         withUserType userType:String,withDocumentType documentType:String,
                         withDocumentNumber documentNumber:String, withEmail email:String,
                         withCurrency currency:String, withPaymentDescription paymentDescription: String) -> [String : Any]{
        
        var requestDictionary = buildJsonObject(withAmount: amount, withCallbackUrl: callbackUrl,
                                                withUserType: userType,withDocumentType: documentType,
                                                withDocumentNumber: documentNumber, withEmail: email,
                                                withCurrency: currency)
        
        requestDictionary["paymentDescription"] = paymentDescription
        
        return requestDictionary
    }
    
    func buildJsonObject(withCard card: Card, withCurrency currency: String, withAmount totalAmount: Double, siftScienceResponse: SiftScienceObject) -> [String : Any] {
        
        var requestDictionary = buildJsonObject(withCard: card, withCurrency: currency)
        
        requestDictionary["totalAmount"] = totalAmount
        requestDictionary["sessionId"] = siftScienceResponse.sessionId
        requestDictionary["userId"] = siftScienceResponse.userId
        return requestDictionary
    }
    
    func buildJsonObject( withAccountNumber accountNumber: String, withAccountType accountType: String, withBankCode bankCode: String, withCurrency currency: String, withDocumentNumber documentNumber: String, withDocumentType documentType: String, withEmail email: String, withLastName lastName: String, withName name: String, withTotalAmount totalAmount: Double) -> [String: Any] {
        let requestDictionary:[String: Any] = [
            "accountNumber": accountNumber,
            "accountType": accountType,
            "bankCode": bankCode,
            "currency": currency,
            "documentNumber": documentNumber,
            "documentType": documentType,
            "email": email,
            "lastName": lastName,
            "name": name,
            "totalAmount": totalAmount,
        ]
        return requestDictionary
        
    }
    
    func buildJsonObject( withCityCode cityCode: String, withExpeditionDate expeditionDate: String, withPhone phone: String, withSecureService secureService: String,withSecureServiceId secureServiceId: String, withStateCode stateCode: String) -> [String: Any] {
        let confrontaInfo: [String: Any] = [
            "confrontaBiometrics":
                [
                    "cityCode": cityCode,
                    "stateCode": stateCode,
                    "phone": phone,
                    "expeditionDate": expeditionDate
                ]
        ]
        
        let requestDictionary:[String: Any] = [
            "secureServiceId": secureServiceId,
            "secureService": secureService,
            "confrontaInfo": confrontaInfo
        ]
        return requestDictionary
        
    }
    
    func buildJsonObject(withAnswers answers: [[String: String]], withQuestionnarieCode questionnarieCode: String, withSecureService secureService: String, withSecureServiceId secureServiceId: String) -> [String: Any] {
        let confrontaInfo: [String: Any] =
                ["questionnaireCode": questionnarieCode,
                 "answers": answers,
            ]
        
        let requestDictionary:[String: Any] = [
            
            "secureService": secureService,
            "secureServiceId": secureServiceId,
            "confrontaInfo": confrontaInfo
           
        ]
        return requestDictionary
        
    }
    
    func buildJsonObject( withName name : String, withLastName lastName: String, withIdentification identification: String, withTotalAmount totalAmount: Double, withCurrency currency: String, withEmail email: String) -> [String: Any] {
        let requestDictionary:[String: Any] = [
            "name": name,
            "lastName": lastName,
            "identification": identification,
            "totalAmount": totalAmount,
            "currency": currency,
            "email": email,
        ]
        return requestDictionary
        
    }
    
    func buildJsonObject(withCurrency currency: String, withDescription description : String, withEmail email: String, withReturnUrl returnUrl: String, withTotalAmount totalAmount: Double) -> [String: Any] {
        let requestDictionary:[String: Any] = [
            "currency": currency,
            "description": description,
            "email": email,
            "returnUrl": returnUrl,
            "totalAmount": totalAmount
        ]
        return requestDictionary
        
    }
    
    func buildJsonObject(withCurrency currency: String, withEmail email: String, withCallbackUrl callbackUrl: String, withCardNumber cardNumber: String) -> [String: Any] {
        let requestDictionary:[String: Any] = [
            "currency": currency,
            "email": email,
            "callbackUrl": callbackUrl,
            "cardNumber": cardNumber
        ]
        return requestDictionary
    }
    
    func createSiftScienceSession(withMerchantId publicMerchantId: String, card: Card, isTest: Bool, merchantSettings: MerchantSettings) -> SiftScienceObject{
            let cardNumber = card.number
        let firstIndex = cardNumber.index(cardNumber.startIndex, offsetBy:CreditCardEspecifications.cardFinalBinPlace.rawValue)
            let endIndex = cardNumber.index(cardNumber.endIndex, offsetBy:-4)
            let processor = cardNumber[..<firstIndex]
            let clientIdentification = cardNumber[endIndex...]
            let session_id = UUID().uuidString;
            let user_id = publicMerchantId + processor + clientIdentification;

            return SiftScienceObject(userId: user_id, sessionId: session_id)
        }

    func buildJsonObject(withSecureServiceId secureServiceId: String, withOtpValue otpValue: String, withSecureService secureService: String) -> [String: Any] {
        let requestDictionary: [String: Any] = [
            "secureServiceId": secureServiceId,
            "otpValue": otpValue,
            "secureService": secureService
        ]
        return requestDictionary
    }

    func buildJsonObject(withSecureServiceId secureServiceId: String, withOtpValue otpValue: String) -> [String: Any] {
        let requestDictionary: [String: Any] = [
            "secureServiceId": secureServiceId,
            "otpValue": otpValue
        ]
        return requestDictionary
    }

    private func showHttpResponse(withMerchantId publicMerchantId: String, endpoint: String, requestBody: String, withCompletion completion: @escaping (String) -> ()) {
        
        let url = URL(string: self.environment.rawValue + endpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestBody.data(using: String.Encoding.utf8)
        request.addValue("application/json; charset=UTF-8",
                         forHTTPHeaderField: "Content-Type")
        request.addValue(publicMerchantId, forHTTPHeaderField: "public-merchant-id")
        let task = URLSession.shared.dataTask (with: request) { data, response, error in
            if let theError = error {
                print(theError.localizedDescription)
                return
            }
            let responseBody = String(data: data!, encoding: String.Encoding.utf8)!
            completion(responseBody)
        }
        task.resume()
    }
    
    private func parseResponse(jsonResponse: String) -> Transaction {
        var token = ""
        var code = "000"
        var message = ""
        var settlement: Double?
        var secureId: String?
        var secureService: String?
        var security: Security = Security(acsURL: "", authenticationTransactionId: "", authRequired: false, paReq: "",specificationVersion: "")
        if let responseDictionary = self.convertStringToDictionary(jsonResponse) {
            if let tokenValue = responseDictionary["token"] as? String {
                token = tokenValue
            }
            else {
                code = responseDictionary["code"] as? String ?? "001"
                message = responseDictionary["message"] as? String ?? "Error inesperado"
            }
            if let settlementValue = responseDictionary["settlement"] as? Double {
                settlement = settlementValue
            }
            if let secureIdValue = responseDictionary["secureId"] as? String{
                secureId = secureIdValue
            }
            if let secureServiceValue = responseDictionary["secureService"] as? String{
                secureService = secureServiceValue
            }
            if (responseDictionary["security"] != nil) {
                let acsURL: String = responseDictionary["security"]?["acsURL"] as? String ?? ""
                let authenticationTransactionId: String = responseDictionary["security"]?["authenticationTransactionId"] as? String ?? ""
                let authRequired: Bool = responseDictionary["security"]?["authRequired"] as? Bool ?? false
                let paReq: String = responseDictionary["security"]?["paReq"] as? String ?? ""
                let specificationVersion: String = responseDictionary["security"]?["specificationVersion"] as? String ?? ""
                security = Security(acsURL: acsURL, authenticationTransactionId: authenticationTransactionId, authRequired: authRequired, paReq: paReq,specificationVersion: specificationVersion)
            }
        }
        else {
            code = "002"
            message = "Hubo un error inesperado, intenta nuevamente"
        }
        return Transaction(code: code, message: message, token: token, settlement: settlement, secureId: secureId, secureService: secureService, security: security)
    }
    
    private func parseValidationResponse(jsonResponse: String) -> ConfrontaResponse {
        var code: String = "BIO010 "
        var message: String = ""
        var questionnarieCode: String = ""
        var questionnarie: [ConfrontaQuestionnarie] = []
        if let responseDictionary = self.convertStringToDictionary(jsonResponse) {
            if let codeValue = responseDictionary["code"] as? String{
                code = codeValue
            }
            else{
                code = "E002"
                message = "Ocurrió un error inesperado"
            }
            if let messageValue = responseDictionary["message"] as? String{
                message = messageValue
            }
            if let questionnarieCodeValue = responseDictionary["questionnaireCode"] as? String{
                questionnarieCode = questionnarieCodeValue
            }
            if let questionsValue = responseDictionary["questions"] as? [AnyObject]{
            
                for question in questionsValue {
                    
                    var id: String = ""
                    var text: String = ""
                    var options: [ConfrontaQuestionOptions] = []
                    
                    if let idValue = question["id"] as? String{
                        id = idValue
                    }
                    if let textValue = question["text"] as? String{
                        text = textValue
                    }
                    if let optionsValues = question["options"] as? [AnyObject]{
                        
                        for option in optionsValues{
                            
                            var textOption: String = ""
                            var idOption: String = ""
                            
                            if let textOptionValue = option["text"] as? String{
                                textOption = textOptionValue
                            }
                            if let idOptionValue = option["id"] as? String{
                                idOption = idOptionValue
                            }
                            let confrontaOptionValue: ConfrontaQuestionOptions = ConfrontaQuestionOptions(text: textOption, id: idOption)
                            options.append(confrontaOptionValue)
                        }
                        
                    }
                    questionnarie.append(ConfrontaQuestionnarie(id: id, text: text, options: options))
                }
            }
        }
        return ConfrontaResponse(code: code, message: message, questionnarieCode: questionnarieCode, questions: questionnarie)
    }
    
    private func parseSecureValidationResponse(jsonResponse: String) -> SecureValidationResponse {
        var code: String = "OTP000"
        var message: String = ""
        if let responseDictionary = self.convertStringToDictionary(jsonResponse) {
            if let codeValue = responseDictionary["code"] as? String {
                code = codeValue
            }
            if let messageValue = responseDictionary["message"] as? String {
                message = messageValue
            }
        } else {
            code = "E002"
            message = "Hubo un error inesperado, intenta nuevamente"
        }

        return SecureValidationResponse(code: code, message: message)
    }

    private func parseSettingsResponse(jsonResponse: String) -> MerchantSettingsResponse {
        var code: String = ""
        var message: String = ""
        var active3ds: Bool = false
        var sandboxEnable: Bool = false
        if let responseDictionary = self.convertStringToDictionary(jsonResponse) {
            if let active3dSecure = responseDictionary["active_3dsecure"] as? Bool {
                active3ds = active3dSecure
            }
            if let sandboxEnableActive = responseDictionary["sandboxEnable"] as? Bool {
                sandboxEnable = sandboxEnableActive
            }
            if (responseDictionary["code"] as? String) != nil {
                code = responseDictionary["code"] as? String ?? "001"
                message = responseDictionary["message"] as? String ?? "Error inesperado"
            }
        } else {
            code = "E002"
            message = "Hubo un error inesperado, intenta nuevamente"
        }
        return MerchantSettingsResponse(active3dsecure: active3ds, code: code, message: message,sandboxEnable: sandboxEnable)
    }

    private func parseJwtResponse(jsonResponse: String) -> JwtResponse {
        var jwt: String = ""
        var code: String = ""
        var message: String = ""
        if let responseDictionary = self.convertStringToDictionary(jsonResponse) {
            if let jwtResp = responseDictionary["jwt"] as? String {
                jwt = jwtResp
            } else {
                code = responseDictionary["code"] as? String ?? "001"
                message = responseDictionary["message"] as? String ?? "error inesperado"
            }
        } else {
            code = "E002"
            message = "Ha ocurrido un error inesperado, intenta nuevamente"
        }
        return JwtResponse(jwt: jwt, code: code, message: message)
    }

    // source: http://stackoverflow.com/questions/30480672/how-to-convert-a-json-string-to-a-dictionary
    private func convertStringToDictionary(_ string: String) -> [String:AnyObject]? {
        if let data = string.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    private func convertStringToArrayDictionary(_ string: String) -> [[String:AnyObject]]? {
        if let data = string.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String:AnyObject]]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    
    private func showHttpGetResponse(withMerchantId publicMerchantId: String, endpoint: String, withCompletion completion: @escaping (String) -> ()) {
        
        let url = URL(string: self.environment.rawValue + endpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(publicMerchantId, forHTTPHeaderField: "public-merchant-id")
        let task = URLSession.shared.dataTask (with: request) { data, response, error in
            if let theError = error {
                print(theError.localizedDescription)
                return
            }
            let responseBody = String(data: data!, encoding: String.Encoding.utf8)!
            completion(responseBody)
        }
        task.resume()
    }
    
    private func showHttpGetResponse(withMerchantId publicMerchantId: String, endpoint: String, param:String , withCompletion completion: @escaping (String) -> ()) {
        
        let url = URL(string: self.environment.rawValue + endpoint + param)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(publicMerchantId, forHTTPHeaderField: "public-merchant-id")
        let task = URLSession.shared.dataTask (with: request) { data, response, error in
            if let theError = error {
                print(theError.localizedDescription)
                return
            }
            let responseBody = String(data: data!, encoding: String.Encoding.utf8)!
            completion(responseBody)
        }
        task.resume()
    }

    private func showHttpGetMerchantSettings(withMerchantId publicMerchantId: String, endpoint: String, withCompletion completion: @escaping (MerchantSettings) -> ()) {

            let url = URL(string: self.environment.rawValue + endpoint)!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(publicMerchantId, forHTTPHeaderField: "public-merchant-id")
            let task = URLSession.shared.dataTask (with: request) { data, response, error in

                print("Data", String(data: data!, encoding: String.Encoding.utf8)!)

                if let theError = error {
                    print(theError.localizedDescription)
                    return
                }

                guard let response = try? JSONDecoder().decode(MerchantSettings.self, from: data!) else {
                    print("Error decoding merchant settings")
                    return
                }

                completion(response)
            }
            task.resume()
        }

    private func parseGetBankListResponse(jsonResponse: String)   -> [Bank] {
        
        var bankList: [Bank] = []
        if let responseDictionary = self.convertStringToArrayDictionary(jsonResponse) {
            for responseBank in responseDictionary{
                var nameBank = ""
                var codeBank = ""
                if let name = (responseBank["name"] as? String) ,let codeResponse = (responseBank["code"] as? String){
                    nameBank = name
                    codeBank = codeResponse
                    let bank = Bank(code: codeBank, name: nameBank)
                    bankList.append(bank)
                }
            }
        }
        
       
        return bankList;
    }
    
    private func parseGetCardInfoResponse(jsonResponse: String)   -> CardInfo {
        
        var bank = ""
        var brand = ""
        var cardType = ""
        if let responseDictionary = self.convertStringToDictionary(jsonResponse) {
            if let bankValue = (responseDictionary["bank"] as? String){
                bank = bankValue
            }
            if let brandValue = (responseDictionary["brand"] as? String){
                brand = brandValue
            }
            if let cardTypeValue = (responseDictionary["cardType"] as? String){
                cardType = cardTypeValue
            }
        }
        return CardInfo(bank: bank, brand: brand, cardType: cardType)
    }

    private func requestMerchantSetting(mid: String, completion: @escaping(MerchantSettingsResponse)->()) {
        get(withMerchantId: mid, endpoint: EndPoint.merchantSettings.rawValue, withCompletion: completion)
    }

    private func requestCybersourceFlow(mid: String, isTest: Bool, endpoint: String, requestMessage: String,isSandboxEnabled:Bool, completion: @escaping(Transaction)->()){
        showHttpGetResponse(withMerchantId: mid, endpoint: EndPoint.cybersourceJwt.rawValue) { response in
            let jwtResp: JwtResponse = self.parseJwtResponse(jsonResponse: response)
            if jwtResp.message == "" {
                let newTokenRequest: TokenRequest3DS = self.parseTokenRequest3DS(jsonResponse: requestMessage, jwt: jwtResp.jwt)
                let newRequestMessage: String = self.buildParameters(withTokenRequest3DS: newTokenRequest)
                        if(isSandboxEnabled){
                            self.showHttpResponse(withMerchantId: mid, endpoint: endpoint, requestBody: newRequestMessage) { transaction in
                                let parsedTransaction = self.parseResponse(jsonResponse: transaction)
                                self.getMerchantSettings(withMerchantId: mid, endpoint: EndPoint.merchantSettings.rawValue) {
                                    settigs in
                                    DispatchQueue.main.async {
                                        let topMostViewController = UIApplication.shared.keyWindow?.rootViewController
                                        let presentedViewController = topMostViewController?.presentedViewController
                                        let frameworkBundleID  = "org.cocoapods.Kushki";
                                        let bundle = Bundle(identifier: frameworkBundleID)
                                        let otp = OTPSandboxViewController(nibName: "OTPSandboxViewController", bundle: bundle)
                                        otp.initValues(merchantName: settigs.merchantName!, currency: newTokenRequest.currency!, amount: newTokenRequest.totalAmount!, cardNumber: newTokenRequest.number)
                                        presentedViewController?.present(otp, animated: true)
                                        completion(parsedTransaction)
                                    }
                                }
                            }
                        } else {
                            self.setupCardinalSession(publicMerchantId: mid, jwt: jwtResp.jwt, isTest: isTest, endpoint: endpoint, requestMessage: newRequestMessage, completion: completion)
                        }
            } else {
                completion(Transaction(code: jwtResp.code, message: jwtResp.message, token: "", settlement: 0, secureId: "", secureService: "", security: Security(acsURL: "", authenticationTransactionId: "", authRequired: false, paReq: "",specificationVersion: "")))
            }

        }
    }

    func setupCardinalSession(publicMerchantId: String, jwt: String, isTest: Bool, endpoint: String, requestMessage: String, completion: @escaping(Transaction)->()) {
        session = CardinalSession()
        let config = CardinalSessionConfiguration()
        config.deploymentEnvironment = isTest ? .staging : .production
        config.uiType = .both
        session.configure(config)
        session.setup(jwtString: jwt, completed: {(consumerSessionId: String) in
            self.showHttpResponse(withMerchantId: publicMerchantId, endpoint: endpoint, requestBody: requestMessage) { transaction in
                let transactionParsed = self.parseResponse(jsonResponse: transaction)
                if(transactionParsed.security!.specificationVersion!.starts(with: "2.") && transactionParsed.security!.authRequired!){
                    self.session.continueWith(transactionId: transactionParsed.security!.authenticationTransactionId!, payload: transactionParsed.security!.paReq!, validationDelegate: self)
                }
                completion(transactionParsed)
            }
        }) {(validateResponse: CardinalResponse) in
            completion(Transaction(code: String(validateResponse.errorNumber), message: validateResponse.errorDescription, token: "", settlement: 0, secureId: "", secureService: "", security: Security(acsURL: "", authenticationTransactionId: "", authRequired: false, paReq: "",specificationVersion: "")))
        }
    }
    
    func cardinalSession(cardinalSession session: CardinalSession!, stepUpValidated validateResponse: CardinalResponse!, serverJWT: String!) {
        print("3DSECURE VALIDATED " + validateResponse.isValidated.description)
    }
    
    private func parseTokenRequest3DS(jsonResponse: String, jwt: String) -> TokenRequest3DS {
        var name: String = ""
        var number: String = ""
        var cvv: String = ""
        var expiryMonth: String = ""
        var expiryYear: String = ""
        var isDeferred: Bool = false
        var months: Int = 0
        var currency: String = ""
        var totalAmount: Double = 0
        var userId: String = ""
        var sessionId: String = ""
        if let responseDictionary = self.convertStringToDictionary(jsonResponse) {
            name = responseDictionary["card"]?["name"] as? String ?? ""
            number = responseDictionary["card"]?["number"] as? String ?? ""
            cvv = responseDictionary["card"]?["cvv"] as? String ?? ""
            expiryMonth = responseDictionary["card"]?["expiryMonth"] as? String ?? ""
            expiryYear = responseDictionary["card"]?["expiryYear"] as? String ?? ""
            isDeferred = responseDictionary["card"]?["isDeferred"] as? Bool ?? false
            months = responseDictionary["card"]?["months"] as? Int ?? 0
            currency = responseDictionary["currency"] as? String ?? ""
            totalAmount = responseDictionary["totalAmount"] as? Double ?? 0
            userId = responseDictionary["userId"] as? String ?? ""
            sessionId = responseDictionary["sessionId"] as? String ?? ""
        }
        return TokenRequest3DS(name: name, number: number, cvv: cvv, expiryMonth: expiryMonth, expiryYear: expiryYear, months: months, isDeferred: isDeferred, jwt: jwt, currency: currency, totalAmount: totalAmount, userId: userId, sessionId: sessionId)
    }

    func buildParameters(withTokenRequest3DS tokenRequest: TokenRequest3DS) -> String {
        let requestDictionary = buildJsonObject(withTokenRequest3DS: tokenRequest)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }

    func buildJsonObject(withTokenRequest3DS tokenRequest: TokenRequest3DS) -> [String : Any] {

        var requestDictionary:[String : Any] = [
            "card": [
                "name": tokenRequest.name,
                "number": tokenRequest.number,
                "expiryMonth": tokenRequest.expiryMonth,
                "expiryYear": tokenRequest.expiryYear,
                "cvv": tokenRequest.cvv
            ],
            "currency": tokenRequest.currency!,
            "jwt": tokenRequest.jwt!,
            "totalAmount": tokenRequest.totalAmount!,
            "userId": tokenRequest.userId!,
            "sessionId": tokenRequest.sessionId!
        ]

        if tokenRequest.months != 0 {
            requestDictionary["months"] = tokenRequest.months
        }
        if tokenRequest.isDeferred {
            requestDictionary["isDeferred"] = tokenRequest.isDeferred
        }
        return requestDictionary
    }
}

