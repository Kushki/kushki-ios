public enum EndPoint: String {
    case token = "/v1/tokens"
    case subscriptionToken = "/v1/subscription-tokens"
    case transferToken = "/transfer/v1/tokens"
    case transferSubscriptionBankList = "/transfer-subscriptions/v1/bankList"
    case transferSubcriptionToken = "/transfer-subscriptions/v1/tokens"
    case transferSubscriptionSecureValidation = "/rules/v1/secureValidation"
}
