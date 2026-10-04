import 'package:aspen_app/model/chat_message_model.dart';

enum ChatStatus {
  initial,
  loading,
  success,
  error,
}

class ChatState {
  final ChatStatus status;
  final List<ChatMessage> messages;

  final bool hasNext;
  final bool loadingMore;

  final DateTime? nextCursorCreatedAt;
  final String? nextCursorId;

  final String? error;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.hasNext = false,
    this.loadingMore = false,
    this.nextCursorCreatedAt,
    this.nextCursorId,
    this.error,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    bool? hasNext,
    bool? loadingMore,

    // true means explicitly set this field to null
    bool clearCursor = false,

    DateTime? nextCursorCreatedAt,
    String? nextCursorId,

    String? error,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      hasNext: hasNext ?? this.hasNext,
      loadingMore: loadingMore ?? this.loadingMore,

      nextCursorCreatedAt:
      clearCursor
          ? null
          : nextCursorCreatedAt ??
          this.nextCursorCreatedAt,

      nextCursorId:
      clearCursor
          ? null
          : nextCursorId ??
          this.nextCursorId,

      error: error ?? this.error,
    );
  }
}