public enum KushkiEnvironment: String {
    // case local = "http://localhost:8888/kushki/api/v1"
    case testing = "https://api-uat.kushkipagos.com"
    case qa = "https://api-qa.kushkipagos.com/card-async/v1"
    case production = "https://api.kushkipagos.com"
    case testing_regional = "https://regional-uat.kushkipagos.com"
    case production_regional = "https://regional.kushkipagos.com"
}
