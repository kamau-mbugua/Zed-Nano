
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zed_nano/contants/AppConstants.dart';
import 'package:zed_nano/networking/datasource/remote/dio/dio_client.dart';
import 'package:zed_nano/networking/datasource/remote/dio/logging_interceptor.dart';
import 'package:zed_nano/providers/SplashProvider.dart';
import 'package:zed_nano/providers/theme_provider.dart';
import 'package:zed_nano/repositories/SplashRepo.dart';
final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));
  //
  // // Repository
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl()));
  // sl.registerLazySingleton(() => AuthenticatedRepo(dioClient: sl(), sharedPreferences: sl()));
  // sl.registerLazySingleton(() => AuthenticatedRepo(dioClient: sl()));
  //
  //
  // // Provider
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  // sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  // sl.registerFactory(() => AuthProvider(authRepo: sl()));
  // sl.registerFactory(() => AuthenticatedAppProviders(authenticatedRepo: sl()));
  // sl.registerFactory(() => CategoryProvider());
  //
  //
  //
  // // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  //
  //
  // //ViewModel
  // sl.registerFactory(() => PaymentViewModel());


}