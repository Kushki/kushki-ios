public enum KushkiEnvironment: String {
    // case local = "http://localhost:8888/kushki/api/v1"
    case testing = "https://api-uat.kushkipagos.com/v1"
    case production = "https://api.kushkipagos.com/v1"
    case testing_regional = "https://regional-uat.kushkipagos.com/v1"
    case production_regional = "https://regional.kushkipagos.com/v1"
}
