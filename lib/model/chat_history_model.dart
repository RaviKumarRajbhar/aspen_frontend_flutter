import 'chat_message_model.dart';

class ChatHistory {
  final List<ChatMessage> messages;
  final bool hasNext;
  final DateTime? nextCursorCreatedAt;
  final String? nextCursorId;

  const ChatHistory({
    required this.messages,
    required this.hasNext,
    this.nextCursorCreatedAt,
    this.nextCursorId,
  });

  factory ChatHistory.fromJson(
      Map<String, dynamic> json,
      ) {
    final List rawMessages =
        json["messages"] ?? [];

    return ChatHistory(
      messages: rawMessages
          .map(
            (e) => ChatMessage.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList(),

      hasNext: json["hasNext"] ?? false,

      nextCursorCreatedAt:
      json["nextCursorCreatedAt"] != null
          ? DateTime.parse(
        json["nextCursorCreatedAt"],
      )
          : null,

      nextCursorId:
      json["nextCursorId"]?.toString(),
    );
  }
}