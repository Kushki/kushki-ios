import Foundation

public class Kushki {
    
    private let publicMerchantId: String
    private let currency: String
    private let kushkiClient: KushkiClient

    public init(publicMerchantId: String, currency: String, environment: KushkiEnvironment) {
        self.publicMerchantId = publicMerchantId
        self.currency = currency
        self.kushkiClient = KushkiClient(environment: environment)
    }
    
    public func requestToken(card: Card,
                             totalAmount: Double,
                             completion: @escaping (Transaction) -> ()) {
        let requestMessage = kushkiClient.buildParameters( withCard: card, withAmount: totalAmount)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/tokens", requestMessage: requestMessage, withCompletion: completion)
    }
    
    public func requestSubscriptionToken(card: Card,
                                         completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withCard: card)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/subscription-tokens", requestMessage: requestMessage, withCompletion: completion)
    }
}
