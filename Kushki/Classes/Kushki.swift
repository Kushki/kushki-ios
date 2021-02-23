import Foundation
import Sift

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
                             totalAmount: Double, isTest: Bool,
                             completion: @escaping (Transaction) -> ()) {
        
        self.getMerchantSettings(){
            merchantSettings in
        
            let siftScienceResponse = self.kushkiClient.createSiftScienceSession(withMerchantId: self.publicMerchantId, card: card, isTest: true, merchantSettings: merchantSettings)
            self.kushkiClient.initSiftScience(merchantSettings: merchantSettings, userId: siftScienceResponse.userId)
            
            let requestMessage = self.kushkiClient.buildParameters(withCard: card, withCurrency: self.currency, withAmount: totalAmount, withSiftScienceResponse: siftScienceResponse)
            
            self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: EndPoint.token.rawValue, requestMessage: requestMessage, withCompletion: completion)
        }
    }
    
    public func requestSubscriptionToken(card: Card, isTest: Bool,
                                         completion: @escaping (Transaction)->()){
      
        self.getMerchantSettings(){
            merchantSettings in
        
            let siftScienceResponse = self.kushkiClient.createSiftScienceSession(withMerchantId: self.publicMerchantId, card: card, isTest: isTest, merchantSettings: merchantSettings)
            self.kushkiClient.initSiftScience(merchantSettings: merchantSettings, userId: siftScienceResponse.userId)
            
            let requestMessage = self.kushkiClient.buildParameters(withCard: card, withCurrency: self.currency)
            
            self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: EndPoint.subscriptionToken.rawValue, requestMessage: requestMessage, withCompletion: completion)
        }
    }
    
    public func requestTransferToken(amount: Amount, callbackUrl:String,userType:String,documentType:String,
                                     documentNumber:String, email:String,
                                     completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withAmount: amount, withCallbackUrl: callbackUrl,
                                                          withUserType: userType,withDocumentType: documentType,
                                                          withDocumentNumber: documentNumber, withEmail: email,
                                                          withCurrency: self.currency)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: EndPoint.transferToken.rawValue, requestMessage: requestMessage, withCompletion: completion)
        
    }
    public func requestTransferToken(amount: Amount, callbackUrl:String,userType:String,documentType:String,
                                     documentNumber:String, email:String,paymentDescription:String,
                                     completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withAmount: amount, withCallbackUrl: callbackUrl,
                                                          withUserType: userType,withDocumentType: documentType,
                                                          withDocumentNumber: documentNumber, withEmail: email,
                                                          withCurrency: self.currency,withPaymentDescription: paymentDescription)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: EndPoint.transferToken.rawValue, requestMessage: requestMessage, withCompletion: completion)
        
    }
    
    public func getBankList(
        completion: @escaping ([Bank]) -> ()){
        self.kushkiClient.get(withMerchantId: self.publicMerchantId, endpoint: EndPoint.transferSubscriptionBankList.rawValue, withCompletion: completion)
    }
    
    public func requestTransferSubscriptionToken( accountNumber: String, accountType: String, bankCode: String, documentNumber: String, documentType: String, email: String, lastname: String, name: String, totalAmount: Double, completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters( withAccountNumber: accountNumber, withAccountType: accountType, withBankCode: bankCode, withCurrency: self.currency, withDocumentNumber: documentNumber, withDocumentType: documentType, withEmail: email, withLastName: lastname, withName: name, withTotalAmount: totalAmount)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: EndPoint.transferSubcriptionToken.rawValue, requestMessage: requestMessage, withCompletion: completion)
    }
    
    public func requestSecureValidation( cityCode: String,expeditionDate: String, phone: String,secureService: String, secureServiceId: String,  stateCode: String , completion: @escaping (ConfrontaResponse)->()){
        let requestMessage = kushkiClient.buildParameters(withCityCode: cityCode, withExpeditionDate : expeditionDate, withPhone: phone, withSecureService: secureService, withSecureServiceId: secureServiceId, withStateCode : stateCode)
        self.kushkiClient.post(withMerchantId: self.publicMerchantId, endpoint: EndPoint.transferSubscriptionSecureValidation.rawValue, requestMessage: requestMessage, withCompletion: completion)
    }
    
    public func requestSecureValidation(answers: [[String: String]], questionnarieCode: String, secureService: String, secureServiceId: String, completion: @escaping (ConfrontaResponse)->()){
        let requestMessage = kushkiClient.buildParameters(withAnswers: answers, withQuestionnarieCode: questionnarieCode, withSecureService: secureService, withSecureServiceId: secureServiceId)
        self.kushkiClient.post(withMerchantId: publicMerchantId, endpoint:EndPoint.transferSubscriptionSecureValidation.rawValue, requestMessage: requestMessage, withCompletion: completion)
        
    }
    
    public func requestCashToken(name : String, lastName: String, identification: String, totalAmount: Double, email: String , completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withName: name, withLastName: lastName, withIdentification: identification, withTotalAmount: totalAmount, withCurrency: self.currency, withEmail: email)
        self.kushkiClient.post(withMerchantId: publicMerchantId, endpoint: EndPoint.cashToken.rawValue, requestMessage: requestMessage, withCompletion: completion)
    }
    
    public func requestCardAsyncToken(description: String = "", email: String = "", returnUrl: String, totalAmount: Double, completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withCurrency: self.currency, withDescription: description, withEmail: email, withReturnUrl: returnUrl, withTotalAmount: totalAmount)
        self.kushkiClient.post(withMerchantId: publicMerchantId, endpoint: EndPoint.cardAsyncToken.rawValue, requestMessage: requestMessage, withCompletion: completion)
    }
    
    public func getCardInfo(cardNumber: String,
        completion: @escaping (CardInfo) -> ()){
        let bin = String(cardNumber[..<cardNumber.index(cardNumber.startIndex, offsetBy: 6)])
        self.kushkiClient.get(withMerchantId: self.publicMerchantId, endpoint: EndPoint.cardInfo.rawValue, withParam: bin , withCompletion: completion)
    }
    
    public func requestSubscriptionCardAsyncToken(email: String, callbackUrl: String, cardNumber: String = "", completion: @escaping (Transaction)->()){
        let requestMessage = kushkiClient.buildParameters(withCurrency: self.currency, withEmail: email, withCallbackUrl: callbackUrl, withCardNumber: cardNumber)
        self.kushkiClient.post(withMerchantId: publicMerchantId, endpoint: EndPoint.subscriptionCardAsyncToken.rawValue, requestMessage: requestMessage, withCompletion: completion)
    }
    
    func getMerchantSettings(completion: @escaping (MerchantSettings) -> ()) {
        self.kushkiClient.get(withMerchantId: self.publicMerchantId, endpoint: EndPoint.merchantSettings.rawValue, withCompletion: completion)
    }
}
