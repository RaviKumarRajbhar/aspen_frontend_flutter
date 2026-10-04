import 'package:flutter/foundation.dart';

enum MessageStatus {
  sent,
  delivered,
  seen,
}

MessageStatus _parseMessageStatus(String? status) {
  switch (status?.toUpperCase()) {
    case "DELIVERED":
      return MessageStatus.delivered;

    case "SEEN":
      return MessageStatus.seen;

    case "SENT":
    default:
      return MessageStatus.sent;
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderUsername;
  final String receiverId;
  final String content;
  final MessageStatus status;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderUsername,
    required this.receiverId,
    required this.content,
    required this.status,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(
      Map<String, dynamic> json,
      ) {
    return ChatMessage(
      id: json["id"].toString(),

      senderId: json["senderId"].toString(),

      senderUsername:
      json["senderUsername"] ?? "",

      receiverId:
      json["receiverId"].toString(),

      content:
      json["content"] ?? "",

      status: _parseMessageStatus(
        json["status"],
      ),

      createdAt: DateTime.parse(
        json["createdAt"],
      ),
    );
  }
}