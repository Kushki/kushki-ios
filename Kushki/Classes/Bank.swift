public struct Bank{
    public let code: String;
    public let name: String;
    
    init(dictionary: [String:Any]) {
        self.code = dictionary["code"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        
    }
}
