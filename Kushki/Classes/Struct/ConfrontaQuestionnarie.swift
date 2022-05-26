public struct ConfrontaQuestionnarie{
    
    public let id: String
    public let text: String
    public let options: [ConfrontaQuestionOptions]
    
    init(id: String, text: String, options: [ConfrontaQuestionOptions]) {
        self.text = text
        self.options = options
        self.id = id
    }

}
