import 'package:equatable/equatable.dart';

import '../../auth/domain/entities/chat_entity.dart';
import '../../auth/domain/entities/message_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}


class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatEntity> chats;

  const ChatLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatCreated extends ChatState {
  final String chatId;

  const ChatCreated(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;

  const MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageSent extends ChatState {}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}