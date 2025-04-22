// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:hr_app/cache/secure_storage.dart';
// import 'package:hr_app/core/helpers/app_log.dart';
// import 'package:hr_app/core/network/network.dart';
// import 'package:hr_app/main.dart';
// import 'package:hr_app/modules/auth_module/view/login_screen.dart';
// import 'package:hr_app/setup_service_locator.dart';

// class CustomInterceptor extends Interceptor {
//   final SecureStorage _secureStorage = SecureStorage();
//   final networkService = sl<NetworkService>();

//   @override
//   void onRequest(
//       RequestOptions options, RequestInterceptorHandler handler) async {
//     if (networkService.shouldCancelApiCalls()) {
//       return handler.reject(DioException(
//         error: 'API call canceled',
//         type: DioExceptionType.cancel,
//         requestOptions: options,
//       ));
//     }

//     final token = await _secureStorage.readToken() ?? "";

//     options.headers.addAll({
//       "Connection": "keep-alive",
//       "Cookie": "session_id=$token",
//       "Content-Type": "application/json",
//       "Accept": "*/*",
//     });

//     handler.next(options);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) async {
//     final statusCode = response.data?['statusCode'];
//     AppLog.d("onResponse statusCode: $statusCode");

//     if (statusCode == -700) {
//       networkService.cancelAllApiCalls();
//       return handler.reject(DioException(
//         error: 'API call canceled',
//         type: DioExceptionType.cancel,
//         requestOptions: response.requestOptions,
//       ));
//     }

//     if (statusCode == -600) {
//       if (kDebugMode) {
//         AppLog.d("onResponse statusCode -600");
//       }

//       await _secureStorage.writeToken(" ");
//       // TODO:❗Don't navigate here directly. Better to emit an event or handle it at a higher level.
//       navigatorKey.currentState?.pushReplacementNamed(LoginScreen.routeName);
//       return handler.reject(DioException(
//         error: 'Session expired',
//         type: DioExceptionType.unknown,
//         requestOptions: response.requestOptions,
//       ));
//     }

//     handler.next(response);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     AppLog.e("Dio Error: ${err.message}", "DioInterceptor");
//     handler.next(err); // Just forward the original DioException
//   }
// }
