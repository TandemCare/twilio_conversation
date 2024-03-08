// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../method_channel_twilio_chat_conversation_platform_interface.dart';

abstract class TwilioChatConversationPlatform extends PlatformInterface {
  /// Constructs a TwilioChatConversation.
  TwilioChatConversationPlatform() : super(token: _token);

  static final Object _token = Object();

  static TwilioChatConversationPlatform _instance =
      MethodChannelTwilioChatConversation();

  /// The default instance of [TwilioChatConversationPlatform] to use.
  ///
  /// Defaults to [MethodChannelUrlLauncher].
  static TwilioChatConversationPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [TwilioChatConversationPlatform] when they register themselves.
  // TODO(amirh): Extract common platform interface logic.
  // https://github.com/flutter/flutter/issues/43368
  static set instance(TwilioChatConversationPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<List?> getConversations() {
    throw UnimplementedError('launch() has not been implemented.');
  }
}
