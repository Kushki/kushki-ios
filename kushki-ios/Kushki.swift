import Foundation

class Kushki {
    
    private let publicMerchantId: String
    private let currency: String
    private let environment: KushkiEnvironment
    private let aurusEncryption: AurusEncryption
    
    
    init(publicMerchantId: String, currency: String, environment: KushkiEnvironment) {
        self.publicMerchantId = publicMerchantId
        self.currency = currency
        self.environment = environment
        self.aurusEncryption = AurusEncryption()
    }

    // Constructor for testing
    init(publicMerchantId: String, currency: String, environment: KushkiEnvironment, aurusEncryption: AurusEncryption) {
        self.publicMerchantId = publicMerchantId
        self.currency = currency
        self.environment = environment
        self.aurusEncryption = aurusEncryption
    }
    
    func requestToken(card: Card, totalAmount: Double, completion: @escaping (Transaction) -> ()) {
        let requestMessage = buildParameters(withMerchantId: self.publicMerchantId, withCard: card, withAmount: totalAmount)
        let encryptedRequestBody = "{\"request\": \"" + aurusEncryption.encrypt(requestMessage) + "\"}"
        self.showHttpResponse(endpoint: "/tokens", requestBody: encryptedRequestBody) { transaction in
            completion(self.parseResponse(jsonResponse: transaction))
        }
    }
    
    private func buildParameters(withMerchantId publicMerchantId: String, withCard card: Card, withAmount totalAmount: Double) -> String {
        let requestDictionary:[String : Any] = [
            "merchant_identifier": publicMerchantId,
            "language_indicator": "es",
            "card": [
                "name": card.name,
                "number": card.number,
                "expiry_month": card.expiryMonth,
                "expiry_year": card.expiryYear,
                "cvv": card.cvv,
                "card_present": "1"
            ],
            "amount": String(format: "%.2f", totalAmount),
            "remember_me": "0",
            "deferred_payment": "0",
            "token_type": "transaction-token"
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: requestDictionary, options: .prettyPrinted)
        let dictFromJson = String(data: jsonData, encoding: String.Encoding.ascii)
        return dictFromJson!
    }

    private func showHttpResponse(endpoint: String, requestBody: String, withCompletion completion: @escaping (String) -> ()) {
        let url = URL(string: self.environment.rawValue + endpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestBody.data(using: String.Encoding.utf8)
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
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
        let responseDictionary = self.convertStringToDictionary(text: jsonResponse)
        let code = responseDictionary!["response_code"] as! String
        let text = responseDictionary!["response_text"] as! String
        let token = responseDictionary!["transaction_token"] as! String
        return Transaction(code: code, text: text, token: token)
    }

    // source: http://stackoverflow.com/questions/30480672/how-to-convert-a-json-string-to-a-dictionary
    private func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}
