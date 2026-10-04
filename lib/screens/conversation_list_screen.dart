import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/conversation_state.dart';
import '../viewmodel/conversation_viewmodel.dart';
import '../widgets/conversation_tile.dart';

class ConversationListScreen extends ConsumerStatefulWidget {
  const ConversationListScreen({super.key});

  @override
  ConsumerState<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends ConsumerState<ConversationListScreen> {

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
    final state = ref.watch(conversationViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),

      body: _buildBody(state),
    );
  }

  Widget _buildBody(ConversationState state) {

    if (state.status == ConversationStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.status == ConversationStatus.error) {
      return Center(
        child: Text(
          state.error ?? "Something went wrong",
        ),
      );
    }

    if (state.conversations.isEmpty) {
      return const Center(
        child: Text(
          "No conversations yet",
        ),
      );
    }

    return ListView.separated(
      itemCount: state.conversations.length,

      separatorBuilder: (_, __) =>
      const Divider(height: 1),

      itemBuilder: (context, index) {
        final conversation =
        state.conversations[index];

        return ConversationTile(
          conversation: conversation,

          onTap: () {
          },
        );
      },
    );
  }
}