import 'dart:async';

import 'package:aspen_app/service/auth_service.dart';
import 'package:aspen_app/token_storage.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {

  final TokenStorage _tokenStorage;
  final AuthService authService;
  final Dio dio;

  AuthInterceptor(
      this._tokenStorage,
      this.authService,
      this.dio,
      );

  bool isRefreshing = false;
  final List<_QueuedRequest> requestQueue = [];


  @override
  Future<void> onRequest( RequestOptions options, RequestInterceptorHandler handler) async {

    final isRefreshApi = options.path.contains("/refresh");

    if (!isRefreshApi) {
      final token = await _tokenStorage.getAccessToken();

      if (token != null) {
        options.headers["Authorization"] =
        "Bearer $token";
      }
    }

    handler.next(options);
  }


  @override
  Future<void> onError( DioException err, ErrorInterceptorHandler handler) async {

    final statusCode = err.response?.statusCode;

    // logic still not complete and correct needs correction
    if (statusCode != 401 && statusCode != 403) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;

    if (requestOptions.path.contains("/refresh")) {

      await _tokenStorage.deleteAccessToken();
      await _tokenStorage.deleteRefreshToken();

      return handler.reject(err);
    }


    final completer = Completer<Response>();

    requestQueue.add(_QueuedRequest(requestOptions,completer));


    if (isRefreshing) {

      return completer.future.then((response) {
          handler.resolve(response);
        },

        onError: (e) {
          if (e is DioException) { handler.reject(e);
          } else {
            handler.reject(DioException(requestOptions: requestOptions,error: e));
          }
        },
      );
    }

    isRefreshing = true;

    try {
      final oldRefreshToken = await _tokenStorage.getRefreshToken();

      if (oldRefreshToken == null) {
        throw Exception("Refresh token missing");
      }
      print("Refreshing token...");

      final newTokens = await authService.refreshToken(oldRefreshToken);

      final accessToken = newTokens.data["accessToken"];
      final refreshToken = newTokens.data["refreshToken"];

      await _tokenStorage.saveAccessToken(accessToken);
      await _tokenStorage.saveRefreshToken(refreshToken);

      print("Token refreshed successfully");

      for (final queuedRequest in requestQueue) {
        try {

          final response = await _retry(queuedRequest.requestOptions);
          queuedRequest.completer.complete(response);

        } catch (e) {
          queuedRequest.completer.completeError(e);
        }
      }

      requestQueue.clear();

      return completer.future.then(

            (response) {

          handler.resolve(response);
        },

        onError: (e) {

          if (e is DioException) {
            handler.reject(e);
          } else {
            handler.reject(
              DioException( requestOptions: requestOptions, error: e),
            );
          }
        },
      );

    } catch (e) {

      for (final queuedRequest in requestQueue) {

        queuedRequest.completer.completeError(

          DioException(
            requestOptions:
            queuedRequest.requestOptions,
            error: "Session expired",
          ),
        );
      }

      requestQueue.clear();

      return handler.reject(err);

    } finally {

      isRefreshing = false;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {

    final token = await _tokenStorage.getAccessToken();

    final options = requestOptions.copyWith(

      headers: {
        ...requestOptions.headers,
        "Authorization":
        "Bearer $token",
      },
    );

    return dio.fetch(options);
  }
}

class _QueuedRequest {

  final RequestOptions requestOptions;

  final Completer<Response> completer;

  _QueuedRequest(this.requestOptions,this.completer);

}