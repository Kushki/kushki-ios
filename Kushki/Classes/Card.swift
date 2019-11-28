public struct Card {
    let name: String
    let number: String
    let cvv: String
    let expiryMonth: String
    let expiryYear: String

    public init(name: String, number: String, cvv: String, expiryMonth: String,
                 expiryYear: String) {
        self.name = name
        self.number = number
        self.cvv = cvv
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
    }
}
