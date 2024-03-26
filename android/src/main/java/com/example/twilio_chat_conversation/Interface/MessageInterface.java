package com.example.twilio_chat_conversation.Interface;

import java.util.Map;

public interface MessageInterface {
    default void onMessageUpdate(Map<String, Object> message) {
    }

    default void onTypingUpdate(boolean isTyping) {
    }

}