import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final void Function(String message) onSend;

  const ChatInput({
    super.key,
    required this.onSend,
  });

  @override
  State<ChatInput> createState() =>
      _ChatInputState();
}

class _ChatInputState
    extends State<ChatInput> {

  final TextEditingController
  _controller = TextEditingController();

  void _send() {
    final text =
    _controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    widget.onSend(text);

    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        10,
        8,
        10,
        8,
      ),

      decoration: BoxDecoration(
        color: Theme.of(context)
            .scaffoldBackgroundColor,

        border: Border(
          top: BorderSide(
            color: Theme.of(context)
                .dividerColor,
          ),
        ),
      ),

      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,

              textInputAction:
              TextInputAction.send,

              onSubmitted: (_) {
                _send();
              },

              decoration: InputDecoration(
                hintText: "Message...",

                contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(24),

                  borderSide: BorderSide.none,
                ),

                filled: true,
              ),
            ),
          ),

          const SizedBox(width: 8),

          IconButton(
            onPressed: _send,
            icon: const Icon(
              Icons.send,
            ),
          ),
        ],
      ),
    );
  }
}