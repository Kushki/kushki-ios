public enum EndPoint: String {
    case token = "/v1/tokens"
    case subscriptionToken = "/v1/subscription-tokens"
    case transferToken = "/transfer/v1/tokens"
    case transferSubscriptionBankList = "/transfer-subscriptions/v1/bankList"
    case transferSubcriptionToken = "/transfer-subscriptions/v1/tokens"
    case transferSubscriptionSecureValidation = "/rules/v1/secureValidation"
    case cashToken = "/cash/v1/tokens"
    case cardAsyncToken = "/card-async/v1/tokens"
    case cardInfo = "/card/v1/bin/"
}
