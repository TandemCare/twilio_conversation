protocol ConversationDelegate: AnyObject {
    func onMessageUpdate(message: [String:Any],  messageSubscriptionId : String)
    func onTypingUpdate(isTyping: Bool)
    func onParticipantAdded(conversationSid: String?, participantIdentity: String?)
}
