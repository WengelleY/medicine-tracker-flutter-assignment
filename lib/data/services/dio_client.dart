import 'package:dio/dio.dart';

class DioClient {
  static const String _baseUrl =
      'https://6a088c0efa9b27c848fb243d.mockapi.io/api/v1';

  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout:
            const Duration(seconds: 15),
        receiveTimeout:
            const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        error: true,
      ),
    );
  }

  Dio get dio => _dio;
}
