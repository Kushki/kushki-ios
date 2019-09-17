public struct ConfrontaQuestionnarie{
    public let code: String
    public let message: String
    public let questionnarieCode: String
    public let questions: [[String:Any]]
    
    init(code: String, message: String, questionnarieCode: String, questions: [[String: Any]]) {
        self.code = code
        self.message = message
        self.questionnarieCode = questionnarieCode
        self.questions = questions
    }
    
    public func isSuccessful() -> Bool {
        return (code == "BIO010")
    }
}

