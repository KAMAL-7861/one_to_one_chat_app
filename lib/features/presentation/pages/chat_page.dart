import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

class ChatPage extends StatelessWidget {
  final String userId;

  const ChatPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(getIt())..loadChats(userId),
      child: Scaffold(
        appBar: AppBar(title: Text("Chats")),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ChatLoaded) {
              return ListView.builder(
                itemCount: state.chats.length,
                itemBuilder: (context, index) {
                  final chat = state.chats[index];
                  return ListTile(
                    title: Text("Chat: ${chat.chatId}"),
                    subtitle: Text("Participants: ${chat.participantIds.join(', ')}"),
                    onTap: () {
                      // Navigate to message screen
                    },
                  );
                },
              );
            } else if (state is ChatError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
