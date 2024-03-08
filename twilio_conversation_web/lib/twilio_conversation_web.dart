
import 'twilio_conversation_web_platform_interface.dart';

class TwilioConversationWeb {
  Future<String?> getPlatformVersion() {
    return TwilioConversationWebPlatform.instance.getPlatformVersion();
  }
}
