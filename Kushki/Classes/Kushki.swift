import Foundation

public class Kushki  {
    
    private let publicMerchantId: String
    private let currency: String
    private let kushkiClient: KushkiClient
    private let returnUrl: String?
    
    public init(publicMerchantId: String, currency: String, environment: KushkiEnvironment, regional: Bool = false, returnUrl: String = "") {
        self.publicMerchantId = publicMerchantId
        self.currency = currency
        self.kushkiClient = KushkiClient(environment: environment, regional: regional)
        self.returnUrl = returnUrl
    }
    
    public func requestToken(card: Card,
                             totalAmount: Double,
                             completion: @escaping (Transaction) -> ()) {
        let requestMessage = kushkiClient.buildParameters( withCard: card, withCurrency: self.currency, withAmount: totalAmount)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/v1/tokens", requestMessage: requestMessage, withCompletion: completion)
    }
    
    public func requestSubscriptionToken(card: Card,
                                         completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withCard: card, withCurrency: self.currency)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/v1/subscription-tokens", requestMessage: requestMessage, withCompletion: completion)
    }
    
    public func requestCardAsyncToken(email: String,
                                      totalAmount: Double,
                                      completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildAsyncParameters(withCurrency: self.currency, withAmount: totalAmount, withUrl: self.returnUrl,  withEmail: email)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/card-async/v1/tokens", requestMessage: requestMessage, withCompletion: completion)
    }
}
