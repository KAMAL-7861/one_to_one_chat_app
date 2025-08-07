import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
   ChatModel({
    required super.chatId,
    required super.participantIds,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chatId'] ?? '',
      participantIds: json['users'] != null
          ? List<String>.from(json['users'])
          : json['participantIds'] != null
          ? List<String>.from(json['participantIds'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'users': participantIds, // Use 'users' to match Firestore structure
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
      chatId: entity.chatId,
      participantIds: entity.participantIds,
    );
  }
}