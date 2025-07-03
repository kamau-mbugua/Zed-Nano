import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zed_nano/contants/AppConstants.dart';
import 'package:zed_nano/networking/datasource/remote/dio/dio_client.dart';
import 'package:zed_nano/networking/datasource/remote/dio/logging_interceptor.dart';
import 'package:zed_nano/providers/business/BusinessProviders.dart';
import 'package:zed_nano/providers/common/SplashProvider.dart';
import 'package:zed_nano/providers/auth/authenticated_app_providers.dart';
import 'package:zed_nano/providers/common/theme_provider.dart';
import 'package:zed_nano/repositories/auth/AuthenticatedRepo.dart';
import 'package:zed_nano/repositories/SplashRepo.dart';
import 'package:zed_nano/repositories/business/BusinessRepo.dart';
import 'package:zed_nano/services/firebase_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Firebase Service
  sl..registerLazySingleton(FirebaseService.new)

  // Core
  ..registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()))
  //
  // // Repository
  ..registerLazySingleton(() => SplashRepo(sharedPreferences: sl()))
  ..registerLazySingleton(() => AuthenticatedRepo(dioClient: sl(), sharedPreferences: sl()))
  ..registerLazySingleton(() => BusinessRepo(dioClient: sl()))
  // sl.registerLazySingleton(() => AuthenticatedRepo(dioClient: sl()));
  //
  //
  // // Provider
  ..registerFactory(() => SplashProvider(splashRepo: sl()))
  // sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  // sl.registerFactory(() => AuthProvider(authRepo: sl()));
  ..registerFactory(() => AuthenticatedAppProviders(authenticatedRepo: sl()))
  ..registerFactory(() => BusinessProviders(businessRepo: sl()));
  // sl.registerFactory(() => CategoryProvider());
  //
  //
  //
  // // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl..registerLazySingleton(() => sharedPreferences)
  ..registerLazySingleton(Dio.new)
  ..registerLazySingleton(LoggingInterceptor.new);
  //
  //
  // //ViewModel
  // sl.registerFactory(() => PaymentViewModel());


}