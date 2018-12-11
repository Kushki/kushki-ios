import Foundation
import Sift

public class Kushki {
    
    private let publicMerchantId: String
    private let currency: String
    private let kushkiClient: KushkiClient
    private let environment: KushkiEnvironment
    

    public init(publicMerchantId: String, currency: String, environment: KushkiEnvironment, regional: Bool = false) {
        self.publicMerchantId = publicMerchantId
        self.currency = currency
        self.kushkiClient = KushkiClient(environment: environment, regional: regional)
        self.environment = environment
    }
    
    public func requestToken(card: Card,
                             totalAmount: Double,
                             completion: @escaping (Transaction) -> ()) {
        let requestMessage = kushkiClient.buildParameters( withCard: card, withAmount: totalAmount)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/card/v1/tokens", requestMessage: requestMessage, withCompletion: completion)
    }
    
    public func requestSubscriptionToken(card: Card,
                                         completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withCard: card)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/card/v1/subscription-tokens", requestMessage: requestMessage, withCompletion: completion)
    }
    
    public func requestSubscriptionChargeToken(subscriptionId: String,
                                         completion: @escaping (Transaction)->()){
        
        self.kushkiClient.get(withMerchantId: self.publicMerchantId, endpoint: "/merchant/v1/merchant/settings"){ merchant in
            if(!merchant.isSuccessful()) {
                completion(Transaction(code: merchant.code, message: merchant.message, token: ""))
                return
            }
            if(merchant.prodAccountId == ""){
                completion(Transaction(code: "K001", message: "Missing anti fraud settings", token: ""))
                return
            }
            let userId = self.publicMerchantId + "-" + subscriptionId
            let sift = Sift.sharedInstance
            sift()?.accountId = self.environment == KushkiEnvironment.production ? merchant.prodAccountId : merchant.sandboxAccountId
            sift()?.beaconKey = self.environment == KushkiEnvironment.production ? merchant.prodBaconKey : merchant.sandboxBaconKey
            sift()?.userId = userId
            self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/subscriptions/v1/card/" + subscriptionId + "/tokens", requestMessage:  self.kushkiClient.buildParameters(withUserId: userId), withCompletion: completion)
        }
    }
}
