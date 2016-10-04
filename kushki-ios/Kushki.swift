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
    
    func requestToken(_ endpoint: String) -> String {
        return aurusEncryption.encrypt(endpoint)
    }

}
