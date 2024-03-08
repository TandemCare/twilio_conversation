import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'twilio_conversation_web_method_channel.dart';

abstract class TwilioConversationWebPlatform extends PlatformInterface {
  /// Constructs a TwilioConversationWebPlatform.
  TwilioConversationWebPlatform() : super(token: _token);

  static final Object _token = Object();

  static TwilioConversationWebPlatform _instance = MethodChannelTwilioConversationWeb();

  /// The default instance of [TwilioConversationWebPlatform] to use.
  ///
  /// Defaults to [MethodChannelTwilioConversationWeb].
  static TwilioConversationWebPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TwilioConversationWebPlatform] when
  /// they register themselves.
  static set instance(TwilioConversationWebPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
