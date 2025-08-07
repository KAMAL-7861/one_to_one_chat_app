
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> getChats(String userId);
  Stream<List<MessageEntity>> getMessages(String chatId);
  Future<void> sendMessage(MessageEntity message);
  Future<void> createChat(ChatEntity chat);
  Future<String> createOrGetChat(String email); // ✅ Add this
}
