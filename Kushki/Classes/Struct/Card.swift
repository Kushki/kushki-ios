public struct Card {
    let name: String
    let number: String
    let cvv: String
    let expiryMonth: String
    let expiryYear: String
    let isDeferred: Bool
    let months: Int

    public init(name: String, number: String, cvv: String, expiryMonth: String,
                expiryYear: String, months: Int = 0, isDeferred: Bool = false) {
        self.name = name
        self.number = number
        self.cvv = cvv
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.months = months
        self.isDeferred = isDeferred
    }
}
