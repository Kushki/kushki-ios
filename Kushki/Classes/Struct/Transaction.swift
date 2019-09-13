public struct Transaction {

    public let code: String
    public let message: String
    public let token: String
    public let settlement: Double?
    public let secureId: String?
    public let secureService: String?

    public func isSuccessful() -> Bool {
        return (code == "000")
    }
}
