public struct Transaction {

    public let code: String
    public let message: String
    public let token: String
    public let settlement: Double?
    public let secureId: String?
    public let secureService: String?
    
    init(code: String, message: String, token: String, settlement: Double = 0.0, secureId: String = "", secureService: String = "") {
        self.code = code
        self.message = message
        self.token = token
        self.settlement = settlement
        self.secureId = secureId
        self.secureService = secureService
    }

    public func isSuccessful() -> Bool {
        return (code == "000")
    }
}
