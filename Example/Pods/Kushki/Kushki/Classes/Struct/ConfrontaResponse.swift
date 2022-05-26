public struct ConfrontaResponse{
    public let code: String
    public let message: String
    public let questionnarieCode: String
    public let questions: [ConfrontaQuestionnarie]
    
    init(code: String, message: String, questionnarieCode: String, questions: [ConfrontaQuestionnarie]) {
        self.code = code
        self.message = message
        self.questionnarieCode = questionnarieCode
        self.questions = questions
    }
    
    public func isSuccessful() -> Bool {
        return (code == "BIO010")
    }
}

