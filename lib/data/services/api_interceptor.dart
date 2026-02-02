import 'package:dio/dio.dart';
import '../../core/constants.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'api-key': AppConstants.apiKey,
      'show-fields': 'thumbnail,trailText',
    });
    return super.onRequest(options, handler);
  }
}
