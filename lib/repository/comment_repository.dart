import 'package:aspen_app/service/comment_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/comment_model.dart';

class CommentRepository {

  final CommentService service;

  CommentRepository(this.service);

  Future<List<CommentModel>> getComments(String postId ) async {
    final response = await service.getComments(postId);

    return response.map((e) => CommentModel.fromJson(e)).toList();
  }

  Future<bool> addComment(String postId , String content )async {
    return await service.addComment(postId, content);
  }
}

final commentRepoProvider = Provider<CommentRepository>((ref) {
  final service = ref.read(commentServiceProvider);
  return CommentRepository(service);
});