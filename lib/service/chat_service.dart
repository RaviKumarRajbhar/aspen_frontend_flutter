import 'package:aspen_app/dio/dio.dart';
import 'package:aspen_app/model/api_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatService {
  final Dio dio;

  ChatService(this.dio);

  Future<ApiResponse<List<Map<String, dynamic>>>> getConversations() async {
    try {
      final response = await dio.get("/chat/conversations");

      final List rawList = response.data;

      final data = rawList.map((e) => Map<String, dynamic>.from(e)).toList();

      return ApiResponse( success: true, data: data );
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? "Something Went Wrong";

      return ApiResponse( success: false, error: message);
    } catch (e) {
      print("CONVERSATION PARSE ERROR: $e");

      return ApiResponse(
        success: false,
        error: "Unexpected Error",
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getConversation({ required String otherUserId, DateTime? cursorCreatedAt, String? cursorId}) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (cursorCreatedAt != null) {
        queryParameters["cursorCreatedAt"] =
            cursorCreatedAt.toIso8601String();
      }

      if (cursorId != null) {
        queryParameters["cursorId"] = cursorId;
      }

      final response = await dio.get("/chat/$otherUserId", queryParameters: queryParameters);

      return ApiResponse(
          success: true,
          data: Map<String, dynamic>.from(response.data));

    } on DioException catch (e) {
  print("CHAT API ERROR");
  print("STATUS: ${e.response?.statusCode}");
  print("DATA: ${e.response?.data}");
  print("MESSAGE: ${e.message}");

  String message = "Something Went Wrong";

  if (e.response?.data is Map) {
  message = e.response?.data["message"] ?? message;
  }
  return ApiResponse( success: false, error: message);
  }catch (e) {
      print("CHAT HISTORY PARSE ERROR: $e");
      return ApiResponse( success: false, error: "Unexpected Error");
    }
  }

  Future<ApiResponse<void>> markMessagesAsSeen({ required String otherUserId }) async {
    try {
      await dio.post("/chat/seen/$otherUserId");

      return ApiResponse(success: true);
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? "Something Went Wrong";
      return ApiResponse( success: false, error: message);
    } catch (e) {
      print("MARK SEEN ERROR: $e");

      return ApiResponse( success: false, error: "Unexpected Error");
    }
  }
}

final chatServiceProvider = Provider<ChatService>((ref) {
  final dio = ref.read(universalDioProvider);
  return ChatService(dio);
});