
public struct CashOutToken {

    public let documentNumber: String
    public let name: String
    public let lastName: String
    public let totalAmount: Double
    public let documentType:DocumentType
    public let currency: String
    public let description: String
    public let email: String
    
    
    public init(documentNumber: String, name: String, lastName: String, totalAmount: Double,
                documentType: DocumentType, currency: String, description: String = "", email:String="") {
        self.documentNumber = documentNumber
        self.name = name
        self.lastName = lastName
        self.totalAmount = totalAmount
        self.documentType = documentType
        self.currency = currency
        self.description = description
        self.email = email
    }
}

public enum DocumentType:String{
    case CC = "CC"
    case NIT = "NIT"
    case CE = "CE"
    case TI = "TI"
    case PP = "PP"
}

