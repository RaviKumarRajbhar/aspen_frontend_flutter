class Conversation {
  final String userId;
  final String username;
  final String? profileUrl;
  final String? lastMessage;
  final bool online;
  final DateTime? lastSeenAt;
  final DateTime? lastMessageTime;
  final int unreadCount;

  const Conversation({
    required this.userId,
    required this.username,
    this.profileUrl,
    this.lastMessage,
    required this.online,
    this.lastSeenAt,
    this.lastMessageTime,
    required this.unreadCount,
  });

  factory Conversation.fromJson(
      Map<String, dynamic> json,
      ) {
    return Conversation(
      userId: json["userId"] as String,
      username: json["username"] as String,
      profileUrl: json["profileUrl"] as String?,
      lastMessage: json["lastMessage"] as String?,
      online: json["online"] ?? false,

      lastSeenAt: json["lastSeenAt"] != null
          ? DateTime.parse(
        json["lastSeenAt"],
      )
          : null,

      lastMessageTime:
      json["lastMessageTime"] != null
          ? DateTime.parse(
        json["lastMessageTime"],
      )
          : null,

      unreadCount: json["unreadCount"] ?? 0,
    );
  }
}