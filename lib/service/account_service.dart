import 'package:aspen_app/dio/dio.dart';
import 'package:aspen_app/model/api_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountService {

  final Dio dio;

  AccountService({required this.dio});

  Future<ApiResponse<Map<String, dynamic>>> getUserInfo() async {

    try {
      final response = await dio.get("/user/my");

      final data = Map<String , dynamic> .from(response.data);

      return ApiResponse(success: true , data: data );
    } on DioException catch (e) {
      final message = e.response?.data?["message"] ?? "Something went wrong";

      return ApiResponse(success: false , error: message);

    } catch (e) {

      return ApiResponse(success: false , error: "Unexpected Error");
    }
  }

}

final accountServiceProvider = Provider<AccountService> ((ref) {
  final dio = ref.read(universalDioProvider);
  return AccountService(dio: dio);
});