import 'package:aspen_app/model/conversation_model.dart';

enum ConversationStatus {
  initial,
  loading,
  success,
  error,
}

class ConversationState {
  final ConversationStatus status;
  final List<Conversation> conversations;
  final String? error;

  const ConversationState({
    this.status = ConversationStatus.initial,
    this.conversations = const [],
    this.error,
  });

  ConversationState copyWith({
    ConversationStatus? status,
    List<Conversation>? conversations,
    String? error,
  }) {
    return ConversationState(
      status: status ?? this.status,
      conversations:
      conversations ?? this.conversations,
      error: error ?? this.error,
    );
  }
}