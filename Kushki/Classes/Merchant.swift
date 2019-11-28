public struct Merchant {
    
    public let sandboxBaconKey: String
    public let prodBaconKey: String
    public let sandboxAccountId: String
    public let prodAccountId: String
    public let code: String
    public let message: String
    
    public func isSuccessful() -> Bool {
        return (code == "")
    }
}

