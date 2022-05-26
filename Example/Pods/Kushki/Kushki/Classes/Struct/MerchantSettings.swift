import Foundation

struct MerchantSettings: Decodable {
    var processors: ProcessorSettings?
    var processorName: String?
    var country: String?
    var sandboxBaconKey: String?
    var prodBaconKey: String?
    var merchantName: String?
    var sandboxAccountId: String?
    var prodAccountId: String?
    var code: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case processors
        case processorName = "processor_name"
        case country
        case sandboxBaconKey
        case prodBaconKey
        case merchantName = "merchant_name"
        case sandboxAccountId
        case prodAccountId
        case code
        case message
    }
}

struct ProcessorSettings: Decodable {
    var card: [ProcessorName]?
    var cash: [ProcessorName]?
    var transfer: [ProcessorName]?
    var payoutsCash: [ProcessorName]?
    var payoutsTransfer: [ProcessorName]?
    var achTransfer: [[String: String]]?
    var transferSubscriptions: [[String: String]]?
    
    enum CodingKeys: String, CodingKey {
        case card
        case cash
        case transfer
        case payoutsCash = "payouts-cash"
        case payoutsTransfer = "payouts-transfer"
        case achTransfer = "ach transfer"
        case transferSubscriptions = "transfer-subscriptions"
    }
}

struct ProcessorName: Decodable {
    let processorName: String
}
