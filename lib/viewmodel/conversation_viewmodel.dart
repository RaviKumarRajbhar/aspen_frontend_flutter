import 'package:aspen_app/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/conversation_model.dart';
import '../states/conversation_state.dart';

class ConversationViewModel
    extends StateNotifier<ConversationState> {
  final ChatRepository repository;

  ConversationViewModel(this.repository)
      : super(const ConversationState());

  Future<void> loadConversations() async {
    state = state.copyWith(
      status: ConversationStatus.loading,
      error: null,
    );

    final response =
    await repository.getConversations();

    if (!response.success) {
      state = state.copyWith(
        status: ConversationStatus.error,
        error: response.error ??
            "Something went wrong",
      );

      return;
    }

    state = state.copyWith(
      status: ConversationStatus.success,
      conversations:
      response.data ?? [],
    );
  }

  void incrementUnreadCount(String senderId) {
    final updatedConversations =
    state.conversations.map((conversation) {
      if (conversation.userId == senderId) {
        return Conversation(
          userId: conversation.userId,
          username: conversation.username,
          profileUrl: conversation.profileUrl,
          lastMessage: conversation.lastMessage,
          online: conversation.online,
          lastSeenAt: conversation.lastSeenAt,
          lastMessageTime: conversation.lastMessageTime,
          unreadCount:
          conversation.unreadCount + 1,
        );
      }

      return conversation;
    }).toList();

    state = state.copyWith(
      conversations: updatedConversations,
    );
  }

  void markConversationAsRead(String userId) {
    final updatedConversations =
    state.conversations.map((conversation) {
      if (conversation.userId == userId) {
        return Conversation(
          userId: conversation.userId,
          username: conversation.username,
          profileUrl: conversation.profileUrl,
          lastMessage: conversation.lastMessage,
          online: conversation.online,
          lastSeenAt: conversation.lastSeenAt,
          lastMessageTime: conversation.lastMessageTime,
          unreadCount: 0,
        );
      }

      return conversation;
    }).toList();

    state = state.copyWith(
      conversations: updatedConversations,
    );
  }
}

final conversationViewModelProvider =
StateNotifierProvider<
    ConversationViewModel,
    ConversationState>((ref) {
  final repository =
  ref.read(chatRepositoryProvider);

  return ConversationViewModel(repository);
});