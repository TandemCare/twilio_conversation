package com.example.twilio_chat_conversation.Interface;

public interface ParticipantInterface {
    default void onParticipantAdded(String conversationSid, String participantIdentity) {
    }

}