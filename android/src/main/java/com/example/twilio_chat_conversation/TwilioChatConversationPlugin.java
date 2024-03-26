package com.example.twilio_chat_conversation;

import androidx.annotation.NonNull;

import com.example.twilio_chat_conversation.Conversation.ConversationHandler;
import com.example.twilio_chat_conversation.Interface.AccessTokenInterface;
import com.example.twilio_chat_conversation.Interface.MessageInterface;
import com.example.twilio_chat_conversation.Interface.ParticipantInterface;
import com.example.twilio_chat_conversation.Utility.Methods;

import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;

/**
 * TwilioChatConversationPlugin
 */
public class TwilioChatConversationPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private EventChannel eventChannel;
    private EventChannel tokenEventChannel;
    private EventChannel participantsEventChannel;
    private EventChannel.EventSink eventSink;
    private EventChannel.EventSink tokenEventSink;
    private EventChannel.EventSink participantsEventSink;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "twilio_chat_conversation");
        channel.setMethodCallHandler(this);

        // Initialize and set StreamHandlers for each EventChannel
        eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "twilio_chat_conversation/onMessageUpdated");
        eventChannel.setStreamHandler(new MessageUpdateStreamHandler());

        tokenEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "twilio_chat_conversation/onTokenStatusChange");
        tokenEventChannel.setStreamHandler(new TokenStatusChangeStreamHandler());

        participantsEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "twilio_chat_conversation/onParticipantUpdate");
        participantsEventChannel.setStreamHandler(new ParticipantUpdateStreamHandler());

        ConversationHandler.flutterPluginBinding = flutterPluginBinding;
    }

    private class MessageUpdateStreamHandler implements StreamHandler {
        private EventSink eventSink;

        @Override
        public void onListen(Object arguments, EventSink events) {
            this.eventSink = events;
            ConversationHandler.setListener(new MessageInterface() {
                @Override
                public void onMessageUpdate(Map<String, Object> message) {
                    if (eventSink != null) {
                        eventSink.success(message);
                    }
                }

                @Override
                public void onTypingUpdate(boolean isTyping) {
                    if (eventSink != null) {
                        eventSink.success(isTyping);
                    }
                }

            });
        }

        @Override
        public void onCancel(Object arguments) {
            this.eventSink = null;
        }
    }

    // Separate StreamHandler for token status changes
    private class TokenStatusChangeStreamHandler implements StreamHandler {
        private EventSink eventSink;

        @Override
        public void onListen(Object arguments, EventSink events) {
            this.eventSink = events;

            ConversationHandler.setTokenListener(new AccessTokenInterface() {
                @Override
                public void onTokenStatusChange(Map message) {
                    /// Pass the message result back to the Flutter side
                    if (eventSink != null) {
                        eventSink.success(message);
                    }
                }

            });
        }


        @Override
        public void onCancel(Object arguments) {
            this.eventSink = null;
        }
    }

    // Separate StreamHandler for participant updates
    private class ParticipantUpdateStreamHandler implements StreamHandler {
        private EventSink eventSink;

        @Override
        public void onListen(Object arguments, EventSink events) {
            this.eventSink = events;

            ConversationHandler.setParticipantListener(new ParticipantInterface() {
                @Override
                public void onParticipantAdded(String conversationSid, String participantIdentity) {
                    /// Pass the message result back to the Flutter side
                    if (eventSink != null) {
                        eventSink.success(participantIdentity);
                    }
                }
            });
        }

        @Override
        public void onCancel(Object arguments) {
            this.eventSink = null;
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        System.out.println("call.method->" + call.method);
        switch (call.method) {
            // To generate twilio access token #
            case Methods.generateToken: //Generate token and authenticate user
                String accessToken = ConversationHandler.generateAccessToken(call.argument("accountSid"), call.argument("apiKey"), call.argument("apiSecret"), call.argument("identity"), call.argument("serviceSid"));
                System.out.println("accessToken generated->" + accessToken);
                result.success(accessToken);
//        ConversationHandler.initializeConversationClient(accessToken,result);
                break;

            case Methods.initializeConversationClient: //Generate token and authenticate user
                ConversationHandler.initializeConversationClient(call.argument("accessToken"), result);
                break;

            // Create new conversation #
            case Methods.createConversation:
                ConversationHandler.createConversation(call.argument("conversationName"), call.argument("identity"), result);
                break;
            // Get list of conversations for logged in user #
            case Methods.getConversations:
                List<Map<String, Object>> conversationList = ConversationHandler.getConversationsList();
                result.success(conversationList);
                break;
            // Get messages from the specific conversation #
            case Methods.getMessages:
                ConversationHandler.getAllMessages(call.argument("conversationSid"), call.argument("messageCount"), result);
                break;
            //Join the existing conversation #
            case Methods.joinConversation:
                String joinStatus = ConversationHandler.joinConversation(call.argument("conversationSid"));
                result.success(joinStatus);
                break;
            // Send message #
            case Methods.sendMessage:
                ConversationHandler.sendMessages(call.argument("message"), call.argument("conversationSid"), Boolean.TRUE.equals(call.argument("isFromChatGpt")), result);
                break;
            // Add participant in a conversation #
            case Methods.addParticipant:
                ConversationHandler.addParticipant(call.argument("participantName"), call.argument("conversationSid"), result);
                break;
            case Methods.removeParticipant:
                ConversationHandler.removeParticipant(call.argument("participantName"), call.argument("conversationSid"), result);
                break;
            // Get & Listen messages from the specific conversation #
            case Methods.receiveMessages:
            case Methods.subscribeToMessageUpdate:
                ConversationHandler.subscribeToMessageUpdate(call.argument("conversationSid"));
                break;
            // Get participants from the specific conversation #
            case Methods.getParticipants:
                ConversationHandler.getParticipants(call.argument("conversationSid"), result);
                break;
            case Methods.unSubscribeToMessageUpdate:
                ConversationHandler.unSubscribeToMessageUpdate(call.argument("conversationSid"));
                break;
            case Methods.updateAccessToken:
                ConversationHandler.updateAccessToken(call.argument("accessToken"), result);
                break;
            case Methods.sendTypingIndicator:
                ConversationHandler.sendTypingIndicator(call.argument("conversationSid"), result);
                break;
            default:
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
        tokenEventChannel.setStreamHandler(null);
        participantsEventChannel.setStreamHandler(null);
    }
}