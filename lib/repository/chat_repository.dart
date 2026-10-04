import 'package:aspen_app/model/api_response.dart';
import 'package:aspen_app/model/chat_history_model.dart';
import 'package:aspen_app/service/chat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/conversation_model.dart';

class ChatRepository {
  final ChatService chatService;

  ChatRepository(this.chatService);

  Future<ApiResponse<List<Conversation>>> getConversations() async {
    final response = await chatService.getConversations();

    if (!response.success) {
      return ApiResponse( success: false, error: response.error );
    }

    final conversations = response.data!.map( (json) => Conversation.fromJson(json) ).toList();

    return ApiResponse( success: true, data: conversations );
  }

  Future<ApiResponse<ChatHistory>> getConversation({ required String otherUserId, DateTime? cursorCreatedAt, String? cursorId }) async {
    final response = await chatService.getConversation( otherUserId: otherUserId, cursorCreatedAt: cursorCreatedAt, cursorId: cursorId );

    if (!response.success) {
      return ApiResponse( success: false, error: response.error );
    }

    final history = ChatHistory.fromJson( response.data! );

    return ApiResponse( success: true, data: history);
  }

  Future<ApiResponse<void>> markMessagesAsSeen({ required String otherUserId }) {
    return chatService.markMessagesAsSeen(otherUserId: otherUserId);
  }
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final service = ref.read(chatServiceProvider);
  return ChatRepository(service);
});