public struct Transfer {
    let amount: Amount
    let callbackUrl: String
    let userType: String
    let documentType: String
    let documentNumber: String
    let email: String
    let currency: String
    let paymentDescription: String
    
    public init(amount: Amount, callbackUrl: String, userType: String, documentType: String,
                documentNumber: String, email: String,currency :String , paymentDescription:String = "" ) {
        self.amount = amount
        self.callbackUrl = callbackUrl
        self.userType = userType
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.email = email
        self.currency = currency
        self.paymentDescription = paymentDescription
    }
}

