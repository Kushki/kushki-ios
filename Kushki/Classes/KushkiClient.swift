import Foundation

private enum KushkiSubscriptionsEnvironment: String {
    // case local = "http://localhost:8888/kushki/api/v1"
    case testing = "https://api-uat.kushkipagos.com/subscriptions/v1"
    case production = "https://api.kushkipagos.com/subscriptions/v1"
    case testing_regional = "https://regional-uat.kushkipagos.com/subscriptions/v1"
    case production_regional = "https://regional.kushkipagos.com/subscriptions/v1"
}

class KushkiClient {
    
    private let environment: KushkiEnvironment
    private let environmentSubscriptions: KushkiSubscriptionsEnvironment
    
    init(environment: KushkiEnvironment, regional: Bool) {
        self.environment = regional ? environment == KushkiEnvironment.production ? KushkiEnvironment.production_regional : KushkiEnvironment.testing_regional : environment
        
        self.environmentSubscriptions = regional ? environment == KushkiEnvironment.production ? KushkiSubscriptionsEnvironment.production_regional : KushkiSubscriptionsEnvironment.testing_regional : environment == KushkiEnvironment.production ? KushkiSubscriptionsEnvironment.production: KushkiSubscriptionsEnvironment.testing

    }
    
    func post(withMerchantId publicMerchantId: String, endpoint: String, requestMessage: String, withCompletion completion: @escaping (Transaction) -> ()) {
        showHttpResponse(withMerchantId: publicMerchantId, endpoint: endpoint, requestBody: requestMessage) { transaction in
            completion(self.parseResponse(jsonResponse: transaction))
        }
    }
    
    func post(withMerchantId publicMerchantId: String, endpoint: String, withCompletion completion: @escaping (Transaction) -> ()) {
        showHttpResponse(withMerchantId: publicMerchantId, endpoint: endpoint) { transaction in
            completion(self.parseResponse(jsonResponse: transaction))
        }
    }
    
    func buildParameters(withCard card: Card) -> String {
        let requestDictionary = buildJsonObject(withCard: card)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.ascii)
        return dictFromJson!
    }
    
    func buildParameters(withCard card: Card, withAmount totalAmount: Double) -> String {
        let requestDictionary = buildJsonObject(withCard: card, withAmount: totalAmount)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.ascii)
        return dictFromJson!
    }
    
    func buildJsonObject(withCard card: Card) -> [String : Any] {
        
        let requestDictionary:[String : Any] = [
            "card": [
                "name": card.name,
                "number": card.number,
                "expiryMonth": card.expiryMonth,
                "expiryYear": card.expiryYear,
                "cvv": card.cvv
            ],
            "currency": "USD"
        ]
        
        return requestDictionary
    }
    
    func buildJsonObject(withCard card: Card, withAmount totalAmount: Double) -> [String : Any] {
        
        var requestDictionary = buildJsonObject(withCard: card)
        
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
    
    private func showHttpResponse(withMerchantId publicMerchantId: String, endpoint: String, withCompletion completion: @escaping (String) -> ()) {
        
        let url = URL(string: self.environmentSubscriptions.rawValue + endpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
        let responseDictionary = self.convertStringToDictionary(jsonResponse)
        if((responseDictionary!["token"]) == nil){
            code = responseDictionary!["code"] as! String
            message = responseDictionary!["message"] as! String
            return Transaction(code: code, message: message, token: token)
        }
        token = responseDictionary!["token"] as! String
        return Transaction(code: code, message: message, token: token)
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
}
