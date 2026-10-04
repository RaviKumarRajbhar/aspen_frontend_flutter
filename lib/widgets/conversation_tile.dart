import 'package:aspen_app/model/conversation_model.dart';
import 'package:flutter/material.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      // Profile image
      leading: CircleAvatar(
        radius: 28,

        backgroundImage: conversation.profileUrl != null
            ? NetworkImage(conversation.profileUrl!)
            : null,

        child: conversation.profileUrl == null
            ? const Icon(
          Icons.person,
          size: 28,
        )
            : null,
      ),

      // Username + online status
      title: Row(
        children: [
          Flexible(
            child: Text(
              conversation.username,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(width: 7),

          // Online / Offline indicator
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: conversation.online
                  ? Colors.green
                  : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),

      // Last message
      subtitle: Padding(
        padding: const EdgeInsets.only(
          top: 5,
        ),
        child: Text(
          conversation.lastMessage ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      // Time + unread count
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(
              conversation.lastMessageTime,
            ),
            style: theme.textTheme.bodySmall,
          ),

          if (conversation.unreadCount > 0) ...[
            const SizedBox(height: 6),

            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),

              child: Text(
                conversation.unreadCount > 99
                    ? "99+"
                    : conversation.unreadCount.toString(),

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}