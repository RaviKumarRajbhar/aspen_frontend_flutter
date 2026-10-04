import 'package:flutter/material.dart';
import 'package:aspen_app/model/chat_message_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
  });

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine
          ? Alignment.centerRight
          : Alignment.centerLeft,

      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),

        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 5,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),

        decoration: BoxDecoration(
          color: isMine
              ? const Color(0xFF5B7CFA) // Happy blue
              : const Color(0xFFE8F7F0), // Soft mint

          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),

            bottomLeft: Radius.circular(
              isMine ? 18 : 5,
            ),

            bottomRight: Radius.circular(
              isMine ? 5 : 18,
            ),
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Flexible(
              child: Text(
                message.content,
                style: TextStyle(
                  color: isMine
                      ? Colors.white
                      : const Color(0xFF263238),
                  fontSize: 16,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(width: 9),

            Text(
              _formatTime(message.createdAt),
              style: TextStyle(
                color: isMine
                    ? Colors.white70
                    : const Color(0xFF78909C),
                fontSize: 11,
              ),
            ),

            if (isMine) ...[
              const SizedBox(width: 4),
              _buildStatusIcon(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    switch (message.status) {
      case MessageStatus.sent:
        return const Icon(
          Icons.check,
          size: 16,
          color: Colors.white70,
        );

      case MessageStatus.delivered:
        return const Icon(
          Icons.done_all,
          size: 16,
          color: Colors.white70,
        );

      case MessageStatus.seen:
        return const Icon(
          Icons.done_all,
          size: 16,
          color: Color(0xFFB8F2E6),
        );
    }
  }
}