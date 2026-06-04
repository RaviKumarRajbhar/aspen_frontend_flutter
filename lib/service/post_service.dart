import 'dart:convert';
import 'dart:io';

import 'package:aspen_app/dio/dio.dart';
import 'package:aspen_app/model/api_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostService {

  final Dio dio;

  PostService(this.dio);

  Future<ApiResponse<List<Map<String, dynamic>>>> getAllPosts() async {
    try {
      final response = await dio.get("/posts/my");

      final List rawList = response.data["content"];

      final data = rawList
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      return ApiResponse(
        success: true,
        data: data,
      );

    } on DioException catch (e) {
      final message =
          e.response?.data?["message"] ??
              "Something Went Wrong";

      return ApiResponse(
        success: false,
        error: message,
      );

    } catch (e) {
      print("POST PARSE ERROR: $e");

      return ApiResponse(
        success: false,
        error: "Unexpected Error",
      );
    }
  }
  
  Future<ApiResponse> uploadPost({required File image , required String caption , required bool isLandscape}) async {
    try{

      final multipartImage = await MultipartFile.fromFile(image.path);

      final formData = FormData.fromMap({
        "image": multipartImage,

        "data": MultipartFile.fromString(
          jsonEncode({
            "caption": caption,
            "isLandscape": isLandscape,
          }),
          contentType: DioMediaType.parse("application/json"),
        ),
      });


      final response = await dio.post( "/posts", data: formData );

      return ApiResponse(success: true );

    } on DioException catch (e) {
      print(e.response?.statusCode);
      return ApiResponse(success: false , error: e.response?.data["message"] ?? "Something went wrong");

    } catch (e) {
      return ApiResponse(success: false , error: "Unexpected Error");
    }
  }
}

final postServiceProvider = Provider<PostService> ((ref) {
  final dio = ref.read(universalDioProvider);
  return PostService(dio);
});