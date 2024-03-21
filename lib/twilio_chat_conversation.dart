import 'dart:async';

import 'package:flutter/services.dart';

import 'twilio_chat_conversation_platform_interface.dart';

/// A class for managing Twilio Chat conversations and communication.
///
/// This class provides a Flutter interface for interacting with Twilio Chat
/// services. It allows you to manage conversations, send and receive messages,
/// and handle token status changes.
class TwilioChatConversation {
  // Event channels for message updates and token status changes.
  static const EventChannel _messageEventChannel =
      EventChannel('twilio_chat_conversation/onMessageUpdated');
  static const EventChannel _tokenEventChannel =
      EventChannel('twilio_chat_conversation/onTokenStatusChange');

  // Stream controllers for message updates and token status changes.
  static final StreamController<Map> _messageUpdateController =
      StreamController<Map>.broadcast();
  static final StreamController<Map> _tokenStatusController =
      StreamController<Map>.broadcast();

  /// Stream for receiving incoming messages.
  Stream<Map> get onMessageReceived => _messageUpdateController.stream;

  Future<String?> getPlatformVersion() {
    return TwilioChatConversationPlatform.instance.getPlatformVersion();
  }

  /// Generates a Twilio Chat token.
  Future<String?> generateToken(
      {required String accountSid,
      required String apiKey,
      required String apiSecret,
      required String identity,
      required serviceSid}) {
    return TwilioChatConversationPlatform.instance.generateToken(
        accountSid: accountSid,
        apiKey: apiKey,
        apiSecret: apiSecret,
        identity: identity,
        serviceSid: serviceSid);
  }

  /// Initializes the Twilio Conversation Client with an access token.
  ///
  /// This method initializes the Twilio Conversation Client using the provided
  /// access token. Once initialized, the client can be used to interact with
  /// conversations and send/receive messages.
  ///
  /// - [accessToken]: The access token used for authentication.
  ///
  /// Returns a [String] indicating the result of the initialization, or `null` if it fails.
  Future<String?> initializeConversationClient({required String accessToken}) {
    return TwilioChatConversationPlatform.instance
        .initializeConversationClient(accessToken: accessToken);
  }

  /// Creates a new conversation.
  ///
  /// This method creates a new conversation with the specified name and identity.
  ///
  /// - [conversationName]: The name of the new conversation.
  /// - [identity]: The identity of the user initiating the conversation.
  ///
  /// Returns a [String] indicating the result of the operation, or `null` if it fails.
  Future<String?> createConversation(
      {required String conversationName, required String identity}) {
    return TwilioChatConversationPlatform.instance.createConversation(
        conversationName: conversationName, identity: identity);
  }

  /// Retrieves a list of conversations.
  ///
  /// This method retrieves a list of conversations available to the user.
  ///
  /// Returns a list of conversations as [List], or `null` if the operation fails.
  Future<List?> getConversations() {
    return TwilioChatConversationPlatform.instance.getConversations();
  }

  /// Retrieves messages from a conversation.
  ///
  /// This method retrieves messages from the specified conversation. The optional
  /// [messageCount] parameter allows you to limit the number of messages to retrieve.
  ///
  /// - [conversationSid]: The ID of the conversation from which to retrieve messages.
  /// - [messageCount]: The maximum number of messages to retrieve (optional).
  ///
  /// Returns a list of messages as [List], or `null` if the operation fails.
  Future<List?> getMessages({
    required String conversationSid,
    int? messageCount,
  }) {
    return TwilioChatConversationPlatform.instance.getMessages(
      conversationSid: conversationSid,
      messageCount: messageCount,
    );
  }

  /// Joins a conversation.
  ///
  /// This method allows a user to join an existing conversation by specifying its ID.
  ///
  /// - [conversationSid]: The ID of the conversation to join.
  ///
  /// Returns a [String] indicating the result of the operation, or `null` if it fails.
  Future<String?> joinConversation(String conversationSid) {
    return TwilioChatConversationPlatform.instance
        .joinConversation(conversationSid);
  }

  /// Sends a message in a conversation.
  ///
  /// This method sends a message in the specified conversation.
  ///
  /// - [message]: The message content to send.
  /// - [conversationSid]: The ID of the conversation in which to send the message.
  ///
  /// Returns a [String] indicating the result of the operation, or `null` if it fails.
  Future<String?> sendMessage({required message, required conversationSid}) {
    return TwilioChatConversationPlatform.instance
        .sendMessage(conversationSid: conversationSid, message: message);
  }

  /// Adds a participant in a conversation.
  ///
  /// - [participantName]: The name of the participant to be added.
  /// - [conversationSid]: The ID of the conversation in which to add the participant.
  Future<String?> addParticipant(
      {required participantName, required conversationSid}) {
    return TwilioChatConversationPlatform.instance.addParticipant(
        conversationSid: conversationSid, participantName: participantName);
  }

  /// Removes a participant from a conversation.
  ///
  /// - [participantName]: The name of the participant to be removed.
  /// - [conversationSid]: The ID of the conversation from which to remove the participant.
  Future<String?> removeParticipant(
      {required participantName, required conversationSid}) {
    return TwilioChatConversationPlatform.instance.removeParticipant(
        conversationSid: conversationSid, participantName: participantName);
  }

  /// Receives messages for a specific conversation.
  ///
  /// - [conversationSid]: The ID of the conversation for which to receive messages.
  ///
  /// Returns a [String] indicating the result of the operation, or `null` if it fails.
  Future<String?> receiveMessages(String conversationSid) {
    return TwilioChatConversationPlatform.instance
        .receiveMessages(conversationSid);
  }

  /// Retrieves a list of participants for a conversation.
  ///
  /// - [conversationSid]: The ID of the conversation for which to retrieve participants.
  ///
  /// Returns a list of participants as [List], or `null` if the operation fails.
  Future<List?> getParticipants(String conversationSid) {
    return TwilioChatConversationPlatform.instance
        .getParticipants(conversationSid);
  }

  /// Subscribes to message update events for a specific conversation.
  void subscribeToMessageUpdate(String conversationSid) async {
    TwilioChatConversationPlatform.instance
        .subscribeToMessageUpdate(conversationSid);
    _messageEventChannel
        .receiveBroadcastStream(conversationSid)
        .listen((dynamic message) {
      if (message != null) {
        if (message["author"] != null && message["body"] != null) {
          _messageUpdateController.add(message);
        }
      }
    });
  }

  /// Unsubscribes from message update events for a specific conversation.
  void unSubscribeToMessageUpdate(String conversationSid) {
    TwilioChatConversationPlatform.instance
        .unSubscribeToMessageUpdate(conversationSid);
  }

  /// Updates the access token used for communication.
  Future<Map?> updateAccessToken({
    required String accessToken,
  }) {
    return TwilioChatConversationPlatform.instance
        .updateAccessToken(accessToken: accessToken);
  }

  Future<String?> sendTypingIndicator(String conversationSid) async {
    final String? result =
        await TwilioChatConversationPlatform.instance.sendTypingIndicator(
      conversationSid,
    );
    return result;
  }

  /// Stream for receiving token status changes.
  Stream<Map> get onTokenStatusChange {
    _tokenEventChannel.receiveBroadcastStream().listen((dynamic tokenStatus) {
      _tokenStatusController.add(tokenStatus);
    });
    return _tokenStatusController.stream;
  }
}
