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
    
    func buildParameters(withCard card: Card, withCurrency currency: String) -> String {
        let requestDictionary = buildJsonObject(withCard: card, withCurrency: currency)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.ascii)
        return dictFromJson!
    }
    
    func buildParameters(withCard card: Card, withCurrency currency: String, withAmount totalAmount: Double) -> String {
        let requestDictionary = buildJsonObject(withCard: card, withCurrency: currency, withAmount: totalAmount)
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.ascii)
        return dictFromJson!
    }
    
    func buildJsonObject(withCard card: Card, withCurrency currency: String) -> [String : Any] {
        
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
        let responseDictionary = self.convertStringToDictionary(jsonResponse)
        if((responseDictionary!["token"]) == nil){
            code = responseDictionary!["code"] as! String
            message = responseDictionary!["message"] as! String
        } else {
            token = responseDictionary!["token"] as! String
        }
        
        if((responseDictionary!["settlement"]) != nil){
            settlement = responseDictionary!["settlement"] as? Double
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
}
