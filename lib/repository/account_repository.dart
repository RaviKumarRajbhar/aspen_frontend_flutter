import 'package:aspen_app/model/api_response.dart';
import 'package:aspen_app/service/account_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user_model.dart';

class AccountRepository {

  final AccountService service;

  AccountRepository(this.service);

  Future<ApiResponse<User>> getInfo() async {

    final response = await service.getUserInfo();

    if(!response.success) {
      return ApiResponse(success: false , error: response.error);
    }

    final user = User.fromJson(response.data!);

    return ApiResponse(success: true, data: user);
  }
}

final accountRepoProvider = Provider<AccountRepository> ((ref) {
  final service = ref.read(accountServiceProvider);
  return AccountRepository(service);
});