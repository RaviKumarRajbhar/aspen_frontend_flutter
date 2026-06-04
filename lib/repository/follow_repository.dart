

import 'package:aspen_app/service/follow_service.dart';
import 'package:aspen_app/model/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowRepository {

  final FollowService service;

  FollowRepository(this.service);


  Future<ApiResponse<List<Map<String , dynamic>>>> getFollowers () async {

    final response = await service.getFollowers();

    if(response.success) {
      final data = response.data!;

      return ApiResponse(success: true , data: data );

    } else {
      return ApiResponse(success: false , error: response.error);
    }

  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getFollowings () async {
    final response = await service.getFollowing();

    if (response.success) {
      final data = response.data!;

      return ApiResponse(success: true, data: data);
    } else {
      return ApiResponse(success: false, error: response.error);
    }
  }

}

final followRepoProvider = Provider<FollowRepository> ((ref) {
  final service = ref.read(followServiceProvider);
  return FollowRepository(service);
});