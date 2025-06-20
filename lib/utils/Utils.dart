// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
//
// import '../widget/base/api_response.dart';
// import '../provider/authenticated_app_providers.dart';
//
// class Utils {
//   String convertObjectToJson(Object object) {
//     if (object is ApiResponse) {
//       return jsonEncode(object.toJson());
//     }
//     return jsonEncode(object);
//   }
// }
//
// AuthenticatedAppProviders getProvider(BuildContext context) {
//   return Provider.of<AuthenticatedAppProviders>(context, listen: false);
// }
//
// Map<String, dynamic> createUserIdPayload(AuthenticatedAppProviders provider) {
//   return {
//     "userId": provider.getLoginResponse()?.result?.data?.userDetails?.userId,
//   };
// }