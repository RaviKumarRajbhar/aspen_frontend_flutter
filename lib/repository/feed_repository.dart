import 'package:aspen_app/model/feed_model.dart';
import 'package:aspen_app/service/feed_service.dart';
import 'package:aspen_app/model/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedRepository {

  final FeedService service;

  FeedRepository(this.service);

  Future<ApiResponse<List<FeedModel>>> getFeed() async {

    final response = await service.getFeed();

    if(!response.success){
      return ApiResponse(success: false, error:  response.error);
    }

    final posts = response.data ?? [];

    final models = posts
    .map((e) => FeedModel.fromJson(e))
    .toList();

    return ApiResponse(success: true , data: models);

  }

  Future<bool> toggleLike(String postId) async {
    final response = await service.toggleLike(postId);
    return response;
  }
}

final feedRepoProvider = Provider<FeedRepository> ((ref) {
  final service = ref.read(feedServiceProvider);
  return FeedRepository(service);
});