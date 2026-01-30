import 'package:get_it/get_it.dart';
import 'utilities.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<Dio>(() => createDioClient());
}
