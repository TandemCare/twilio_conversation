import 'package:flutter_test/flutter_test.dart';
import 'package:twilio_conversation_web/twilio_conversation_web.dart';
import 'package:twilio_conversation_web/twilio_conversation_web_platform_interface.dart';
import 'package:twilio_conversation_web/twilio_conversation_web_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTwilioConversationWebPlatform
    with MockPlatformInterfaceMixin
    implements TwilioConversationWebPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TwilioConversationWebPlatform initialPlatform = TwilioConversationWebPlatform.instance;

  test('$MethodChannelTwilioConversationWeb is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTwilioConversationWeb>());
  });

  test('getPlatformVersion', () async {
    TwilioConversationWeb twilioConversationWebPlugin = TwilioConversationWeb();
    MockTwilioConversationWebPlatform fakePlatform = MockTwilioConversationWebPlatform();
    TwilioConversationWebPlatform.instance = fakePlatform;

    expect(await twilioConversationWebPlugin.getPlatformVersion(), '42');
  });
}
