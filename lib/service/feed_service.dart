import 'package:aspen_app/dio/dio.dart';
import 'package:aspen_app/model/api_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedService {
  final Dio feedDio;

  FeedService(this.feedDio);

  Future<ApiResponse<List<Map<String, dynamic>>>> getFeed() async {
    try {
      final response = await feedDio.get("/feed");

      final data = response.data;

      if (data is Map<String , dynamic>) {
        final posts = data["posts"];

        if(posts is List) {
          final feed = posts.map((e) {
            if (e is Map<String , dynamic>) {
              return e;
            }
            return Map<String , dynamic>.from(e);
          }).toList();

          return ApiResponse(success: true , data: feed);
        }
      }

      return ApiResponse(
        success: false,
        error: "Invalid response format",
      );

    } on DioException catch (e) {

      final message = (e.response?.data is Map<String, dynamic>)
          ? e.response?.data["message"] : "Failed to load feed";

      return ApiResponse(success: false, error: message);

    } catch (e) {
      return ApiResponse(
        success: false,
        error: "Unexpected Error",
      );
    }
  }

  Future<bool> toggleLike(String postId) async {
    try {
      final response = await feedDio.post("/like/$postId");

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}


final feedServiceProvider = Provider<FeedService>((ref) {
  final dio = ref.read(universalDioProvider);
  return FeedService(dio);
});