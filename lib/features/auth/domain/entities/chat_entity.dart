import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String chatId;
  final List<String> participantIds;

  const ChatEntity({
    required this.chatId,
    required this.participantIds,
  });

  @override
  List<Object?> get props => [chatId, participantIds];
}