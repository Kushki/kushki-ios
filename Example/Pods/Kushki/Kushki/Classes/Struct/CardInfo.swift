public struct CardInfo{
    public let bank: String
    public let brand: String
    public let cardType: String
    init(bank: String, brand: String, cardType: String) {
        self.bank = bank
        self.brand = brand
        self.cardType = cardType
    }
}
