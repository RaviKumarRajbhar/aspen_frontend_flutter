import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/chat_message_model.dart';
import '../repository/chat_repository.dart';
import '../states/chat_state.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  final ChatRepository repository;

  ChatViewModel(this.repository) : super(const ChatState());

  Future<void> loadMessages(String otherUserId) async {
    state = state.copyWith(
      status: ChatStatus.loading,
      messages: const [],
      hasNext: false,
      loadingMore: false,
      clearCursor: true,
      error: null,
    );

    try {
      final response = await repository.getConversation(
        otherUserId: otherUserId,
      );

      if (!response.success) {
        state = state.copyWith(
          status: ChatStatus.error,
          error: response.error ?? "Something went wrong",
        );
        return;
      }

      final history = response.data!;

      // Backend sends newest -> oldest.
      // Keep this order because ChatScreen uses reverse:true.
      final messages = history.messages.toList();

      state = state.copyWith(
        status: ChatStatus.success,
        messages: messages,
        hasNext: history.hasNext,
        nextCursorCreatedAt: history.nextCursorCreatedAt,
        nextCursorId: history.nextCursorId,
      );
    } catch (e) {
      print("LOAD CHAT ERROR: $e");

      state = state.copyWith(
        status: ChatStatus.error,
        error: "Failed to load messages",
      );
    }
  }

  // NEW: Add incoming WebSocket message to chat.
  void addIncomingMessage(ChatMessage message) {
    state = state.copyWith(
      messages: [
        message,
        ...state.messages,
      ],
    );
  }

  void updateMessageStatus(
      String messageId,
      MessageStatus status,
      ) {
    final updatedMessages = state.messages.map((message) {
      if (message.id == messageId) {
        return ChatMessage(
          id: message.id,
          senderId: message.senderId,
          senderUsername: message.senderUsername,
          receiverId: message.receiverId,
          content: message.content,
          status: status,
          createdAt: message.createdAt,
        );
      }

      return message;
    }).toList();

    state = state.copyWith(
      messages: updatedMessages,
    );
  }

  Future<void> loadMoreMessages(String otherUserId) async {
    if (!state.hasNext || state.loadingMore) return;

    state = state.copyWith(
      loadingMore: true,
    );

    try {
      final response = await repository.getConversation(
        otherUserId: otherUserId,
        cursorCreatedAt: state.nextCursorCreatedAt,
        cursorId: state.nextCursorId,
      );

      if (!response.success) {
        state = state.copyWith(
          loadingMore: false,
        );
        return;
      }

      final history = response.data!;

      // Backend sends older messages in newest -> oldest order.
      final olderMessages = history.messages.toList();

      // Current state:
      //
      // [newest -> oldest]
      //
      // Older messages need to be appended at the END.
      final updatedMessages = [
        ...state.messages,
        ...olderMessages,
      ];

      state = state.copyWith(
        messages: updatedMessages,
        hasNext: history.hasNext,
        loadingMore: false,
        nextCursorCreatedAt: history.nextCursorCreatedAt,
        nextCursorId: history.nextCursorId,
      );
    } catch (e) {
      print("LOAD MORE CHAT ERROR: $e");

      state = state.copyWith(
        loadingMore: false,
      );
    }
  }

  Future<void> markMessagesAsSeen(String otherUserId) async {
    try {
      await repository.markMessagesAsSeen(
        otherUserId: otherUserId,
      );
    } catch (e) {
      print("MARK SEEN ERROR: $e");
    }
  }
}

final chatViewModelProvider =
StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  final repository = ref.read(chatRepositoryProvider);

  return ChatViewModel(repository);
});