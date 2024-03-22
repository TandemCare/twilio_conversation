import UIKit
import TwilioConversationsClient
import Flutter

class ConversationsHandler: NSObject, TwilioConversationsClientDelegate {
    
    
    
    private var client: TwilioConversationsClient?
    weak var conversationDelegate: ConversationDelegate?
//    weak var tokenDelegate:TokenDelegate?
    public var messageSubscriptionId: String = ""
    var tokenEventSink: FlutterEventSink?

    // Called whenever a conversation we've joined receives a new message
    func conversationsClient(_ client: TwilioConversationsClient, conversation: TCHConversation,
                    messageAdded message: TCHMessage) {
        guard client.synchronizationStatus == .completed else {
            return
        }
        
                self.getMessageInDictionary(message) { messageDictionary in
            if let messageDict = messageDictionary {
                var updatedMessage: [String: Any] = [:]
                print("updatedMessage-----")
                print(updatedMessage)
                updatedMessage["conversationSid"] = conversation.sid ?? ""
                updatedMessage["message"] = messageDict
                self.conversationDelegate?.onMessageUpdate(message: updatedMessage, messageSubscriptionId: self.messageSubscriptionId)
            }
        }
    }


    func conversationsClient(_ client: TwilioConversationsClient, typingStartedOn conversation: TCHConversation, participant: TCHParticipant) {
       print("Typing started")
       self.conversationDelegate?.onTypingUpdate(isTyping: true)
        // Implement your logic to handle the typing started event
        // For example, you could notify the Flutter side via an event channel
    }

    func conversationsClient(_ client: TwilioConversationsClient, typingEndedOn conversation: TCHConversation, participant: TCHParticipant) {
        print("Typing ended")
        self.conversationDelegate?.onTypingUpdate(isTyping: false)
        // Implement your logic to handle the typing ended event
        // Similar to typingStarted, notify Flutter about the event
    }
    
    func conversationsClientTokenWillExpire(_ client: TwilioConversationsClient) {
        print("Access token will expire.->\(String(describing: tokenEventSink))")
        var tokenStatusMap: [String: Any] = [:]
        tokenStatusMap["statusCode"] = 200
        tokenStatusMap["message"] = Strings.accessTokenWillExpire
        tokenEventSink?(tokenStatusMap)
    }
    
    func conversationsClient(_ client: TwilioConversationsClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        print("status->\(status.hashValue)--\(client.synchronizationStatus)")
        
        guard status == .completed else {
            return
        }
        
//            checkConversationCreation { (_, conversation) in
//               if let conversation = conversation {
//                   self.joinConversation(conversation)
//               } else {
//                   self.createConversation { (success, conversation) in
//                       if success, let conversation = conversation {
//                           self.joinConversation(conversation)
//                       }
//                   }
//               }
//            }
        }
    
    func conversationsClientTokenExpired(_ client: TwilioConversationsClient) {
        print("Access token expired.\(String(describing: tokenEventSink))")
        var tokenStatusMap: [String: Any] = [:]
        tokenStatusMap["statusCode"] = 401
        tokenStatusMap["message"] = Strings.accessTokenExpired
        tokenEventSink?(tokenStatusMap)
    }
    
    public func updateAccessToken(accessToken:String,completion: @escaping (TCHResult?) -> Void) {
        self.client?.updateToken(accessToken, completion: { tchResult in
            completion(tchResult)
        })
    }

    func sendMessage(conversationSid:String, messageText: String,
                     completion: @escaping (TCHResult, TCHMessage?) -> Void) {
            self.getConversationFromId(conversationSid: conversationSid) { conversation in
            conversation?.prepareMessage().setBody(messageText).buildAndSend(completion: { tchResult, tchMessages in
                completion(tchResult,tchMessages)
            })
        }
    }
    
    func loginWithAccessToken(_ token: String, completion: @escaping (TCHResult?) -> Void) {
        // Set up Twilio Conversations client
        TwilioConversationsClient.conversationsClient(withToken: token,
         properties: nil,
         delegate: self) { (result, client) in
           self.client = client
            completion(result)
        }
    }

    func shutdown() {
        if let client = client {
            client.delegate = nil
            client.shutdown()
            self.client = nil
        }
    }

    func createConversation(uniqueConversationName:String,_ completion: @escaping (Bool, TCHConversation?,String) -> Void) {
        guard let client = client else {
            return
        }
        // Create the conversation if it hasn't been created yet
        let options: [String: Any] = [
            TCHConversationOptionUniqueName: uniqueConversationName,
            TCHConversationOptionFriendlyName: uniqueConversationName,
            ]
        client.createConversation(options: options) { (result, conversation) in
            if result.isSuccessful {
                completion(result.isSuccessful, conversation,result.resultText ?? "Conversation created.")
            } else {
                completion(false, conversation,result.error?.localizedDescription ?? "Conversation NOT created.")
            }
        }
    }

    func getConversations(_ completion: @escaping([TCHConversation]) -> Void) {
        guard let client = client else {
            return
        }
        guard client.synchronizationStatus == .completed else {
            return
        }
        completion(client.myConversations() ?? [])
    }
    
    func getParticipants(conversationSid:String,_ completion: @escaping([TCHParticipant]) -> Void) {
        self.getConversationFromId(conversationSid: conversationSid) { conversation in
            completion(conversation?.participants() ?? [])
        }
    }
    
    func addParticipants(conversationSid:String,participantName:String,_ completion: @escaping(TCHResult?) -> Void) {
        self.getConversationFromId(conversationSid: conversationSid) { conversation in
            conversation?.addParticipant(byIdentity: participantName, attributes: nil,completion: { status in
                completion(status)
            })
        }
    }
    
    func removeParticipants(conversationSid:String,participantName:String,_ completion: @escaping(TCHResult?) -> Void) {
        self.getConversationFromId(conversationSid: conversationSid) { conversation in
            conversation?.removeParticipant(byIdentity: participantName,completion: { status in
                print("status->\(status)")
                completion(status)
            })
        }
    }


    func joinConversation(_ conversation: TCHConversation,_ completion: @escaping(String?) -> Void) {
        if conversation.status == .joined {
//            self.loadPreviousMessages(conversation,1000) { listOfMessages in
//
//            }
        } else {
            conversation.join(completion: { result in
                if result.isSuccessful {
//                    self.loadPreviousMessages(conversation,1000) { listOfMessages in
//
//                    }
                }
            })
        }
        completion(conversation.sid)
    }
    
    func getConversationFromId(conversationSid:String,_ completion: @escaping(TCHConversation?) -> Void){
        guard let client = client else {
            return
        }
        guard client.synchronizationStatus == .completed else {
            return
        }
        client.conversation(withSidOrUniqueName: conversationSid) { (result, conversation) in
            if let conversationFromSid = conversation {
                completion(conversationFromSid)
            }
        }
    }
    
    func loadPreviousMessages(_ conversation: TCHConversation,_ messageCount: UInt?,_ completion: @escaping([[String: Any]]?) -> Void) {
        print("synchronizationStatus->\(client?.synchronizationStatus == .completed)")
        guard client?.synchronizationStatus == .completed else {
            return
        }
        var listOfMessagess: [[String: Any]] = []
        conversation.getLastMessages(withCount: messageCount ?? 1000) { (result, messages) in
            if let messagesList = messages {
                messagesList.forEach { message in
                    self.getMessageInDictionary(message) { messageDictionary in
                        if let messageDict = messageDictionary {
                            listOfMessagess.append(messageDict)
                        }
                    }
                }
                completion(listOfMessagess)
            }
        }
    }

    func sendTypingIndicator(conversationSid: String, completion: @escaping (String) -> Void) {
        getConversationFromId(conversationSid: conversationSid) { conversation in
            guard let conversation = conversation else {
                completion("Conversation not found")
                return
            }
            conversation.typing()
            completion("Typing indicator sent")
        }
    }

    
    func getMessageInDictionary(_ message:TCHMessage,_ completion: @escaping([String: Any]?) -> Void) {
        var dictionary: [String: Any] = [:]
        var attachedMedia: [[String: Any]] = []
        
        message.attachedMedia.forEach { media in
            var mediaDictionary: [String: Any] = [:]
            mediaDictionary["filename"] = media.filename ?? ""
            mediaDictionary["contentType"] = media.contentType
            mediaDictionary["sid"] = media.sid
            mediaDictionary["description"] = media.description
            mediaDictionary["size"] = media.size
            attachedMedia.append(mediaDictionary)
        }

        dictionary["sid"] = message.participantSid
        dictionary["author"] = message.author
        dictionary["body"] = message.body
        dictionary["attributes"] = message.attributes()?.string
        dictionary["dateCreated"] = message.dateCreated
        dictionary["participant"] = message.participant?.identity
        dictionary["participantSid"] = message.participantSid
        dictionary["description"] = message.description
        dictionary["index"] = message.index
        dictionary["attachedMedia"] = attachedMedia
        completion(dictionary)
    }
}
