import Foundation

public class Kushki {
    
    private let publicMerchantId: String
    private let currency: String
    private let kushkiClient: KushkiClient

    public init(publicMerchantId: String, currency: String, environment: KushkiEnvironment, regional: Bool = false) {
        self.publicMerchantId = publicMerchantId
        self.currency = currency
        self.kushkiClient = KushkiClient(environment: environment, regional: regional)
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
    
    public func requestTransferToken(amount: Amount, callbackUrl:String,userType:String,documentType:String,
                                     documentNumber:String, email:String,
                                     completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withAmount: amount, withCallbackUrl: callbackUrl,
                                                          withUserType: userType,withDocumentType: documentType,
                                                          withDocumentNumber: documentNumber, withEmail: email,
                                                          withCurrency: self.currency)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/transfer/v1/tokens", requestMessage: requestMessage, withCompletion: completion)
        
    }
    public func requestTransferToken(amount: Amount, callbackUrl:String,userType:String,documentType:String,
                                     documentNumber:String, email:String,paymentDescription:String,
                                     completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withAmount: amount, withCallbackUrl: callbackUrl,
                                                          withUserType: userType,withDocumentType: documentType,
                                                          withDocumentNumber: documentNumber, withEmail: email,
                                                          withCurrency: self.currency,withPaymentDescription: paymentDescription)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: "/transfer/v1/tokens", requestMessage: requestMessage, withCompletion: completion)
        
    }
    
    public func getBankList(
        completion: @escaping ([Bank]) -> ()){
        
        self.kushkiClient.get(withMerchantId: self.publicMerchantId, endpoint: "/bankList", withCompletion: completion)
    }
   
    
}
