import Foundation

class KushkiClient {

    private let environment: KushkiEnvironment
    
    init(environment: KushkiEnvironment, regional: Bool) {
        self.environment = regional ? environment == KushkiEnvironment.production ? KushkiEnvironment.production_regional : KushkiEnvironment.testing_regional : environment
    }
    
    func post(withMerchantId publicMerchantId: String, endpoint: String, requestMessage: String, withCompletion completion: @escaping (Transaction) -> ()) {
        showHttpResponse(withMerchantId: publicMerchantId, endpoint: endpoint, requestBody: requestMessage) { transaction in
            completion(self.parseResponse(jsonResponse: transaction))
        }
    }
    
    func post(withMerchantId publicMerchantId: String, endpoint: String, requestMessage: String, withCompletion completion: @escaping (ConfrontaQuestionnarie) -> ()){
        showHttpResponse(withMerchantId: publicMerchantId, endpoint: endpoint, requestBody: requestMessage) { response in
            completion(self.parseValidationResponse(jsonResponse: response))
        }
    }
    
    func post(withMerchantId publicMerchantId: String, endpoint: String, requestMessage: String, withCompletion completion: @escaping (InfoResponse) -> ()){
        showHttpResponse(withMerchantId: publicMerchantId, endpoint: endpoint, requestBody: requestMessage) { response in
            completion(self.parseValidationQuestionsResponse(jsonResponse: response))
        }
    }
    
    func get(withMerchantId publicMerchantId: String, endpoint: String, withCompletion completion: @escaping ([Bank]) -> ()) {
        showHttpGetResponse(withMerchantId: publicMerchantId, endpoint: endpoint) {
            bankList in
            completion(self.parseGetBankListResponse(jsonResponse: bankList))
        }
    }
    
    func buildParameters(withCard card: Card, withCurrency currency: String) -> String {
        let requestDictionary = buildJsonObject(withCard: card, withCurrency: currency)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.utf8)
        return dictFromJson!
    }
    
    func buildParameters(withCard card: Card, withCurrency currency: String, withAmount totalAmount: Double) -> String {
        let requestDictionary = buildJsonObject(withCard: card, withCurrency: currency, withAmount: totalAmount)
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
    
    func buildJsonObject(withCard card: Card, withCurrency currency: String, withAmount totalAmount: Double) -> [String : Any] {
        
        var requestDictionary = buildJsonObject(withCard: card, withCurrency: currency)
        
        requestDictionary["totalAmount"] = totalAmount
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
            
        }
        else {
            code = "002"
            message = "Hubo un error inesperado, intenta nuevamente"
        }
        return Transaction(code: code, message: message, token: token, settlement: settlement, secureId: secureId, secureService: secureService)
    }
    
    private func parseValidationResponse(jsonResponse: String) -> ConfrontaQuestionnarie {
        var code: String = "BIO010 "
        var message: String = ""
        var questionnarieCode: String = ""
        var questions: [[String: Any]] = []
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
            if let questionsValue = responseDictionary["questions"] as? [[String: Any]]{
                questions = questionsValue
            }
            
        }
        return ConfrontaQuestionnarie(code: code, message: message, questionnarieCode: questionnarieCode, questions: questions)
    }
    
    private func parseValidationQuestionsResponse(jsonResponse: String) -> InfoResponse {
        var code: String = ""
        var message: String = ""
        if let responseDictionary = self.convertStringToDictionary(jsonResponse) {
            if let codeValue = responseDictionary["code"] as? String, let messageValue = responseDictionary["message"] as? String {
                code = codeValue
                message = messageValue
            }
            else {
                code = responseDictionary["code"] as? String ?? "001"
                message = responseDictionary["message"] as? String ?? "Error inesperado"
            }
        }
        return InfoResponse(code: code, message: message)
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
    

}
