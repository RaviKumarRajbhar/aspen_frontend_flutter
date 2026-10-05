import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aspen_app/token_storage.dart';
import 'package:aspen_app/service/chat_websocket_service.dart';

import '../model/chat_message_model.dart';
import '../states/chat_state.dart';
import '../viewmodel/chat_viewmodel.dart';
import '../viewmodel/conversation_viewmodel.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String otherUserId;
  final String username;
  final String? profileUrl;

  const ChatScreen({
    super.key,
    required this.otherUserId,
    required this.username,
    this.profileUrl,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final ChatWebSocketService _webSocketService = ChatWebSocketService();

  String? currentUserId;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    Future.microtask(() async {
      await _loadCurrentUserId();

      if (!mounted) return;

      await _connectWebSocket();

      if (!mounted) return;

      await _loadInitialMessages();

      if (!mounted) return;

      ref
          .read(conversationViewModelProvider.notifier)
          .markConversationAsRead(widget.otherUserId);

      await ref
          .read(chatViewModelProvider.notifier)
          .markMessagesAsSeen(widget.otherUserId);
    });
  }

  Future<void> _loadCurrentUserId() async {
    final tokenStorage = ref.read(tokenStorageProvider);
    final userId = await tokenStorage.getUserId();

    if (!mounted) return;

    setState(() {
      currentUserId = userId;
    });
  }

  Future<void> _connectWebSocket() async {
    final tokenStorage = ref.read(tokenStorageProvider);
    final accessToken = await tokenStorage.getAccessToken();

    if (accessToken == null) {
      print("WEBSOCKET: Access token missing");
      return;
    }

    _webSocketService.connect(accessToken: accessToken);

    print("WEBSOCKET: Connected");

    _webSocketService.stream?.listen(
          (data) {
        print("WEBSOCKET RECEIVED: $data");

        try {
          final json = jsonDecode(data);

          final message =
          ChatMessage.fromJson(Map<String, dynamic>.from(json));

          final chatViewModel =
          ref.read(chatViewModelProvider.notifier);

          if (message.status == MessageStatus.seen) {
            chatViewModel.updateMessageStatus(
              message.id,
              MessageStatus.seen,
            );
          } else {
            chatViewModel.addIncomingMessage(message);

            ref
                .read(conversationViewModelProvider.notifier)
                .markConversationAsRead(widget.otherUserId);
          }
        } catch (e) {
          print("Error :$e");
        }
      },
      onError: (error) {
        print("Error: $error");
      },
      onDone: () {
        print("connection closed");
      },
    );
  }

  Future<void> _loadInitialMessages() async {
    final viewModel = ref.read(chatViewModelProvider.notifier);

    await viewModel.loadMessages(widget.otherUserId);

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.jumpTo(0);
      _isInitialLoading = false;
    });
  }

  Future<void> _refreshMessages() async {
    final viewModel = ref.read(chatViewModelProvider.notifier);

    _isInitialLoading = true;

    await viewModel.loadMessages(widget.otherUserId);

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.jumpTo(0);

      _isInitialLoading = false;
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_isInitialLoading) return;

    final state = ref.read(chatViewModelProvider);

    if (state.status != ChatStatus.success) return;

    if (state.loadingMore) return;

    if (!state.hasNext) return;

    final position = _scrollController.position;

    if (position.maxScrollExtent <= 0) return;

    if (position.pixels >= position.maxScrollExtent - 100) {
      _loadMoreMessages();
    }
  }

  Future<void> _loadMoreMessages() async {
    final viewModel = ref.read(chatViewModelProvider.notifier);
    final state = ref.read(chatViewModelProvider);

    if (!state.hasNext || state.loadingMore) return;

    await viewModel.loadMoreMessages(widget.otherUserId);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    _webSocketService.disconnect();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFE8F7F0),
              backgroundImage:
              widget.profileUrl != null &&
                  widget.profileUrl!.isNotEmpty
                  ? NetworkImage(widget.profileUrl!)
                  : null,
              child: widget.profileUrl == null ||
                  widget.profileUrl!.isEmpty
                  ? const Icon(
                Icons.person,
                color: Color(0xFF5B7CFA),
              )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.username,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshMessages,
              child: _buildMessageList(state),
            ),
          ),
          ChatInput(
            onSend: (message) {
              _webSocketService.sendMessage(
                receiverId: widget.otherUserId,
                content: message,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(ChatState state) {
    if (state.status == ChatStatus.loading &&
        state.messages.isEmpty &&
        _isInitialLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.status == ChatStatus.error &&
        state.messages.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Text(
                state.error ?? "Something went wrong",
              ),
            ),
          ),
        ],
      );
    }

    if (state.messages.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 500,
            child: Center(
              child: Text("No messages yet"),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          reverse: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: state.messages.length,
          itemBuilder: (context, index) {
            final message = state.messages[index];

            final isMine = message.senderId == currentUserId;

            return MessageBubble(
              message: message,
              isMine: isMine,
            );
          },
        ),
        if (state.loadingMore)
          const Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}