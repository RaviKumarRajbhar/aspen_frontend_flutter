
import 'dart:io';

import 'package:aspen_app/model/api_response.dart';
import 'package:aspen_app/service/post_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostRepository {

  final PostService service;

  PostRepository(this.service);

  Future<ApiResponse<List<Map<String , dynamic>>>> getAllPosts () async {

    final response = await service.getAllPosts();

    if(!response.success){
      return ApiResponse(success: false , error: response.error);
    }

    final data  = response.data!;

    return ApiResponse(success: true , data : data);


  }
  



  Future<void> uploadPost({required File image , required String caption, required bool isLandscape})
  async {

    final multipartImage = image;

    final response = await service.uploadPost(image: multipartImage, caption: caption, isLandscape: isLandscape);


  }

}

final postRepoProvider = Provider<PostRepository> ((ref) {
  final service = ref.read(postServiceProvider);
  return PostRepository(service);
});