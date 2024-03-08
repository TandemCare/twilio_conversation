import 'dart:async';

import 'package:flutter/services.dart';

import 'twilio_chat_conversation_platform_interface.dart';

const _channel = MethodChannel('twilio_chat_conversation');

/// An implementation of [UrlLauncherPlatform] that uses method channels.
class MethodChannelTwilioChatConversation
    extends TwilioChatConversationPlatform {
  @override
  Future<List?> getConversations() async {
    final List? conversationsList =
        await _channel.invokeMethod('getConversations');
    return conversationsList ?? [];
  }
}
