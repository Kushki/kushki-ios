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
        }
        else {
            code = "002"
            message = "Hubo un error inesperado, intenta nuevamente"
        }
        return Transaction(code: code, message: message, token: token, settlement: settlement)
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
        request.addValue(publicMerchantId, forHTTPHeaderField: "Public-Merchant-Id")
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
    
    private func parseGetBankListResponse(jsonResponse: String) -> [Bank] {
        var bankList: [Bank] = []
        if let responseDictionary = self.convertStringToArrayDictionary(jsonResponse) {
            for responseBank in responseDictionary{
                var nameBank = ""
                var codeBank = ""
                
                if let name = responseBank["name"] as? String{
                    nameBank = name
                }
                if let codeResponse = responseBank["code"] as? String{
                    codeBank = codeResponse
                }
                let bank = Bank(code: codeBank, name: nameBank)
                bankList.append(bank)
            }
        }
        return bankList;
    }

}
