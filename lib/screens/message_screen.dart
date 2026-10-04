import 'package:aspen_app/states/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/conversation_viewmodel.dart';
import '../widgets/conversation_tile.dart';
import 'chat_screen.dart';

class MessageScreen extends ConsumerStatefulWidget {
  const MessageScreen({super.key});

  @override
  ConsumerState<MessageScreen> createState() => MessageScreenState();
}

class MessageScreenState extends ConsumerState<MessageScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(conversationViewModelProvider.notifier)
          .loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState =
    ref.watch(conversationViewModelProvider);

    if (chatState.status ==
        ChatStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (chatState.status ==
        ChatStatus.error) {
      return Center(
        child: Text(
          chatState.error ??
              "Something went wrong",
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),

      body: ListView.separated(
        itemCount:
        chatState.conversations.length,

        separatorBuilder: (_, __) {
          return const Divider(
            height: 1,
          );
          },

        itemBuilder: (context, index) {
          final conversation =
          chatState.conversations[index];

          return ConversationTile(
            conversation: conversation,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    otherUserId: conversation.userId,
                    username: conversation.username,
                    profileUrl: conversation.profileUrl,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}