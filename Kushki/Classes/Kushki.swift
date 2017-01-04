import Foundation

public class Kushki {
    
    private let publicMerchantId: String
    private let currency: String
    private let aurusClient: AurusClient

    public convenience init(publicMerchantId: String, currency: String, environment: KushkiEnvironment) {
        self.init(publicMerchantId: publicMerchantId, currency: currency, environment: environment, aurusEncryption: AurusEncryption())
    }

    // Constructor for testing
    init(publicMerchantId: String, currency: String, environment: KushkiEnvironment, aurusEncryption: AurusEncryption) {
        self.publicMerchantId = publicMerchantId
        self.currency = currency
        self.aurusClient = AurusClient(environment: environment, aurusEncryption: aurusEncryption)
    }
    
    public func requestToken(card: Card,
                             totalAmount: Double,
                             completion: @escaping (Transaction) -> ()) {
        let requestMessage = aurusClient.buildParameters(withMerchantId: self.publicMerchantId, withCard: card, withAmount: totalAmount)
        self.aurusClient.post(endpoint: "/tokens", requestMessage: requestMessage, withCompletion: completion)
    }
    
    public func requestSubscriptionToken(card: Card,
                                         completion: @escaping (Transaction)->()){
        let requestMessage = aurusClient.buildParameters(withMerchantId: self.publicMerchantId, withCard: card)
        self.aurusClient.post(endpoint: "/tokens", requestMessage: requestMessage, withCompletion: completion)
    }
}
