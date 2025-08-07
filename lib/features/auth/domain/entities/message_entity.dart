import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String messageId;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime timestamp;

  const MessageEntity({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    messageId,
    chatId,
    senderId,
    text,
    timestamp,
  ];
}