public enum EndPoint: String {
    case token = "/v1/tokens"
    case subscriptionToken = "/v1/subscription-tokens"
    case transferToken = "/transfer/v1/tokens"
    case transferSubscriptionBankList = "/transfer-subscriptions/v1/bankList"
    case transferSubcriptionToken = "/transfer-subscriptions/v1/tokens"
    case transferSubscriptionSecureValidation = "/rules/v1/secureValidation"
    case cashToken = "/cash/v1/tokens"
    case cardAsyncToken = "/card-async/v1/tokens"
    case cardInfo = "/deferred/v2/bin/"
    case subscriptionCardAsyncToken = "/subscriptions/v1/card-async/tokens"
    case merchantSettings = "/merchant/v1/merchant/settings"
    case cybersourceJwt = "/card/v1/authToken"
}
