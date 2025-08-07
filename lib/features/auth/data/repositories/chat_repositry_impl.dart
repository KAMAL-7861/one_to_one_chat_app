import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'chat_repositry.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<ChatEntity>> getChats(String userId) {
    return remoteDataSource.getChats(userId);
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return remoteDataSource.getMessages(chatId);
  }

  @override
  Future<String> createOrGetChat(String email) async {
    return remoteDataSource.createOrGetChat(email); // Delegate to data source
  }

  @override
  Future<void> sendMessage(MessageEntity message) {
    return remoteDataSource.sendMessage(MessageModel(
      messageId: message.messageId,
      chatId: message.chatId,
      senderId: message.senderId,
      text: message.text,
      timestamp: message.timestamp,
    ));
  }

  @override
  Future<void> createChat(ChatEntity chat) {
    return remoteDataSource.createChat(ChatModel(
      chatId: chat.chatId,
      participantIds: chat.participantIds,
    ));
  }
}