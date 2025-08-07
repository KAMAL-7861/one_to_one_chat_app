import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/data/repositories/chat_repositry.dart';
import '../../auth/domain/entities/message_entity.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  StreamSubscription? _chatsSubscription;
  StreamSubscription? _messagesSubscription;

  ChatCubit(this.chatRepository) : super(ChatInitial());

  void loadChats(String userId) {
    emit(ChatLoading());
    try {
      _chatsSubscription?.cancel();
      _chatsSubscription = chatRepository.getChats(userId).listen(
            (chats) {
          emit(ChatLoaded(chats));
        },
        onError: (error) {
          emit(ChatError(error.toString()));
        },
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void loadMessages(String chatId) {
    emit(MessagesLoading());
    try {
      _messagesSubscription?.cancel();
      _messagesSubscription = chatRepository.getMessages(chatId).listen(
            (messages) {
          emit(MessagesLoaded(messages));
        },
        onError: (error) {
          emit(ChatError(error.toString()));
        },
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMessage(MessageEntity message) async {
    try {
      await chatRepository.sendMessage(message);
      emit(MessageSent());
      // Messages will be automatically updated through the stream
    } catch (e) {
      emit(ChatError('Failed to send message: ${e.toString()}'));
    }
  }

  Future<void> createOrGetChat(String email) async {
    try {
      print('🚀 ChatCubit: Starting createOrGetChat for email: $email');
      emit(ChatLoading());
      print('🚀 ChatCubit: Emitted ChatLoading state');

      final chatId = await chatRepository.createOrGetChat(email)
          .timeout(Duration(seconds: 15)); // Increased timeout

      print('🚀 ChatCubit: Got chatId: $chatId');
      print('🚀 ChatCubit: About to emit ChatCreated state');
      emit(ChatCreated(chatId));
      print('🚀 ChatCubit: Emitted ChatCreated state with chatId: $chatId');
    } catch (e) {
      print('❌ ChatCubit: Error occurred: $e');
      if (e is TimeoutException) {
        print('❌ ChatCubit: Timeout error');
        emit(ChatError('Request timed out. Please check your internet connection.'));
      } else {
        print('❌ ChatCubit: General error: ${e.toString()}');
        emit(ChatError('Failed to create chat: ${e.toString()}'));
      }
    }
  }
  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    _messagesSubscription?.cancel();
    return super.close();
  }
}