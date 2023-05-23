import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:stock_counting_app/services/store.dart';

class DioInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await Store.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type'] = 'application/json';

    super.onRequest(options, handler);
  }
}
