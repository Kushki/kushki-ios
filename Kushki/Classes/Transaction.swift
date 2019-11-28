public struct Transaction {

    public let code: String
    public let message: String
    public let token: String

    public func isSuccessful() -> Bool {
        return (code == "000")
    }
}
