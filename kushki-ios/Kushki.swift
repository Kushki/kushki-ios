class Kushki {
    
    let publicMerchantId: String
    let currency: String
    let environment: KushkiEnvironment
    let aurusEncryption: AurusEncryption
    
    
    init(publicMerchantId: String, currency: String, environment: KushkiEnvironment, aurusEncryption: AurusEncryption) {
        self.publicMerchantId = publicMerchantId
        self.currency = currency
        self.environment = environment
        self.aurusEncryption = aurusEncryption
    }
    
    func requestToken(card: Card, totalAmount: Double) -> Transaction {
        return Transaction(code: "", text: "", token: "")
    }

}
