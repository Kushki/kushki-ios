public struct Transaction {

    public let code: String
    public let message: String
    public let token: String
    public let settlement: Double?

    public func isSuccessful() -> Bool {
        return (code == "000")
    }
}
