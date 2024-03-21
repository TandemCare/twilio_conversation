import 'dart:async';

import 'package:flutter/services.dart';

import 'twilio_chat_conversation_platform_interface.dart';

/// An implementation of [TwilioChatConversationPlatform] that uses method channels.
class MethodChannelTwilioChatConversation
    extends TwilioChatConversationPlatform {
  /// The method channel used to interact with the native platform.
  final _channel = const MethodChannel('twilio_chat_conversation');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await _channel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  /// Generate token and authenticate user (only for Android) #
  @TargetPlatform.android
  @override
  Future<String?> generateToken({
    required String accountSid,
    required String apiKey,
    required String apiSecret,
    required String identity,
    required String serviceSid,
  }) async {
    final accessToken = await _channel.invokeMethod<String>('generateToken', {
      "accountSid": accountSid,
      "apiKey": apiKey,
      "apiSecret": apiSecret,
      "identity": identity,
      "serviceSid": serviceSid
    });
    return accessToken;
  }

  /// Create new conversation #
  @override
  Future<String?> createConversation({
    required String conversationName,
    required String identity,
  }) async {
    final result = await _channel.invokeMethod<String>('createConversation', {
      "conversationName": conversationName,
      "identity": identity,
    });
    return result;
  }

  /// Get list of conversations for logged in user #
  @override
  Future<List?> getConversations() async {
    final List? conversationsList =
        await _channel.invokeMethod('getConversations');
    return conversationsList ?? [];
  }

  /// Get messages from the specific conversation #
  @override
  Future<List?> getMessages({
    required String conversationId,
    int? messageCount,
  }) async {
    final List? messages = await _channel.invokeMethod('getMessages', {
      "conversationId": conversationId,
      "messageCount": messageCount,
    });
    //print("messages->$messages");
    return messages ?? [];
  }

  /// Join the existing conversation #
  @override
  Future<String?> joinConversation({required String conversationId}) async {
    final String? result =
        await _channel.invokeMethod<String>('joinConversation', {
      "conversationId": conversationId,
    });
    return result ?? "";
  }

  /// Send message #
  @override
  Future<String?> sendMessage({
    required String conversationId,
    required String message,
  }) async {
    final String? result = await _channel.invokeMethod<String>('sendMessage', {
      "conversationId": conversationId,
      "message": message,
    });
    return result ?? "";
  }

  /// Add participant in a conversation #
  @override
  Future<String?> addParticipant({
    required String conversationId,
    required String participantName,
  }) async {
    final String? result =
        await _channel.invokeMethod<String>('addParticipant', {
      "conversationId": conversationId,
      "participantName": participantName,
    });
    return result ?? "";
  }

  /// Get messages from the specific conversation #
  @override
  Future<String?> receiveMessages({required String conversationId}) async {
    final String? result =
        await _channel.invokeMethod<String>('receiveMessages', {
      "conversationId": conversationId,
    });
    return result ?? "";
  }

  /// Get participants from the specific conversation #
  @override
  Future<List?> getParticipants({required String conversationId}) async {
    final List? participantsList =
        await _channel.invokeMethod('getParticipants', {
      "conversationId": conversationId,
    });
    return participantsList ?? [];
  }

  @override
  Future<String> subscribeToMessageUpdate({
    required String conversationId,
  }) async {
    //
    final String? result =
        await _channel.invokeMethod('subscribeToMessageUpdate', {
      "conversationId": conversationId,
    });
    return result ?? "";
  }

  @override
  Future<String> unSubscribeToMessageUpdate({
    required String conversationId,
  }) async {
    final String? result =
        await _channel.invokeMethod('unSubscribeToMessageUpdate', {
      "conversationId": conversationId,
    });
    return result ?? "";
  }

  @override
  Future<String?> initializeConversationClient({
    required String accessToken,
  }) async {
    final String? result =
        await _channel.invokeMethod('initializeConversationClient', {
      "accessToken": accessToken,
    });
    return result ?? "";
  }

  @override
  Future<Map?> updateAccessToken({required String accessToken}) async {
    // TODO: implement updateAccessToken
    final Map? result = await _channel.invokeMethod('updateAccessToken', {
      "accessToken": accessToken,
    });
    return result ?? {};
  }

  @override
  Future<String?> removeParticipant({
    required conversationId,
    required participantName,
  }) async {
    final String? result =
        await _channel.invokeMethod<String>('removeParticipant', {
      "conversationId": conversationId,
      "participantName": participantName,
    });
    return result ?? "";
  }

  /// Sends a typing indicator to the conversation.
  @override
  Future<String?> sendTypingIndicator(String conversationSid) async {
    final String? result = await _channel.invokeMethod('sendTypingIndicator', {
      'conversationSid': conversationSid,
    });
    return result;
  }
}
