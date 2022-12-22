public struct TokenRequest3DS {
    let name: String
    let number: String
    let cvv: String
    let expiryMonth: String
    let expiryYear: String
    let isDeferred: Bool
    let months: Int
    let jwt: String?
    let currency: String?
    let totalAmount: Double?
    let userId: String?
    let sessionId: String?
    
    public init(name: String, number: String, cvv: String, expiryMonth: String,
                expiryYear: String, months: Int = 0, isDeferred: Bool = false, jwt: String = "", currency: String = "", totalAmount: Double = 0, userId: String = "", sessionId: String = "") {
        self.name = name
        self.number = number
        self.cvv = cvv
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.months = months
        self.isDeferred = isDeferred
        self.currency = currency
        self.totalAmount = totalAmount
        self.jwt = jwt
        self.userId = userId
        self.sessionId = sessionId
    }
}
