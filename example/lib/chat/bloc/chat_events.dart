import 'package:equatable/equatable.dart';

abstract class ChatEvents extends Equatable {}

class GenerateTokenEvent extends ChatEvents {
  final Map credentials;
  GenerateTokenEvent({required this.credentials});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class UpdateTokenEvent extends ChatEvents {
  UpdateTokenEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitializeConversationClientEvent extends ChatEvents {
  final String accessToken;
  InitializeConversationClientEvent({required this.accessToken});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// CreateConversion
class CreateConversationEvent extends ChatEvents {
  final String conversationName;
  final String? identity;
  CreateConversationEvent(
      {required this.conversationName, required this.identity});

  @override
  List<Object?> get props => throw UnimplementedError();
}

// JoinConversion
class JoinConversionEvent extends ChatEvents {
  final String conversationSid;
  final String conversationName;
  JoinConversionEvent(
      {required this.conversationSid, required this.conversationName});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//SendMessage
class SendMessageEvent extends ChatEvents {
  final String? enteredMessage;
  final String? conversationName;
  final bool? isFromChatGpt;
  SendMessageEvent(
      {required this.enteredMessage,
      required this.conversationName,
      required this.isFromChatGpt});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//SendMessage
class ReceiveMessageEvent extends ChatEvents {
  final String? conversationSid;
  final int? messageCount;
  ReceiveMessageEvent({required this.conversationSid, this.messageCount});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//AddParticipant
class AddParticipantEvent extends ChatEvents {
  final String participantName;
  final String conversationName;
  AddParticipantEvent(
      {required this.participantName, required this.conversationName});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//RemoveParticipant
class RemoveParticipantEvent extends ChatEvents {
  final String participantName;
  final String conversationName;
  RemoveParticipantEvent(
      {required this.participantName, required this.conversationName});

  @override
  List<Object?> get props => throw UnimplementedError();
}

//SeeMyConversationsEvent
class SeeMyConversationsEvent extends ChatEvents {
  SeeMyConversationsEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetParticipantsEvent extends ChatEvents {
  final String conversationSid;
  GetParticipantsEvent({required this.conversationSid});

  @override
  List<Object?> get props => [conversationSid];
}
