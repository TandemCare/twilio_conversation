import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'twilio_conversation_web_platform_interface.dart';

/// An implementation of [TwilioConversationWebPlatform] that uses method channels.
class MethodChannelTwilioConversationWeb extends TwilioConversationWebPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('twilio_conversation_web');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
