package com.example.twilio_chat_conversation.Interface;

import java.util.Map;

public interface ParticipantInterface {
    default void onParticipantAdded(String conversationSid, String participantIdentity) {
    }

}