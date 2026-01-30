import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'constants.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
  ),
);

// Dio Singleton setup
Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.i("REQUEST[${options.method}] => PATH: ${options.path}");
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        logger.e(
          "ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}",
        );
        return handler.next(e);
      },
    ),
  );

  return dio;
}
