import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dio/dio.dart';

class CommentService {

  final Dio commentDio;

  CommentService(this.commentDio);

  Future<List<Map<String,dynamic>>> getComments(
      String postId,
      ) async {

    final response =
    await commentDio.get(
      "/comment/$postId",
    );

    final data =
        response.data;

    final content =
    data["content"] as List;

    return content
        .map(
          (e) => Map<String,dynamic>.from(e),
    )
        .toList();
  }

  Future<bool> addComment(String postId , String content ) async {

    try{
      await commentDio.post("/comment/$postId",
      data: {"content" : content });

      return true;
    } catch (e) {
      return false;
    }
  }

}

final commentServiceProvider = Provider<CommentService>((ref) {
  final dio = ref.read(universalDioProvider);
  return CommentService(dio);
});