protocol ConversationDelegate: AnyObject {
    func onMessageUpdate(message: [String:Any],  messageSubscriptionId : String)
    func onTypingUpdate(isTyping: [bool])
}
