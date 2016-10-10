public struct Transaction {

    public let code: String
    public let text: String
    public let token: String

    public func isSucessful() -> Bool {
        return (code == "000")
    }
}
