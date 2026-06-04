import 'package:aspen_app/dio/dio.dart';
import 'package:aspen_app/model/api_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowService{

  final Dio dio;

  FollowService(this.dio);

  Future<ApiResponse<List<Map<String , dynamic >>>> getFollowers() async {
    try {
      final response = await dio.get("/follow/followers");

      final followers = (response.data["content"] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      return ApiResponse(success: true, data: followers);
    } on DioException catch (e) {
      return ApiResponse(success: false , error: e.response?.data["message"] ?? "Something went wrong");

    } catch (e) {

      return ApiResponse(success: false , error: "Unexpected Error");
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getFollowing() async {
    try {
      final response = await dio.get("/follow/following");

      final following = (response.data["content"] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      return ApiResponse(success: true , data: following);
    } on DioException catch(e) {
      return ApiResponse(success: false , error:  e.response?.data["message"] ?? "Something went wrong");
    } catch(e){
      return ApiResponse(success: false , error: "Unexpected Error");
    }
  }
}

final followServiceProvider = Provider<FollowService> ((ref) {
  final dio = ref.read(universalDioProvider);
  return FollowService(dio);
});