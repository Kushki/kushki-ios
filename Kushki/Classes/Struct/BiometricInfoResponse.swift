public struct InfoResponse{
    public let code: String
    public let message: String
    public init(code: String, message: String){
            self.code = code
            self.message = message
        }
    public func isSuccessful() -> Bool {
        return (code == "BIO000")
    }
    
    
}

