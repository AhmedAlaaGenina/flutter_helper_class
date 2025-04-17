import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:dio/io.dart' as ad;
import 'package:flutter/foundation.dart';
import 'package:hr_app/cache/secure_storage.dart';
import 'package:hr_app/core/environments/app_flavor.dart';
import 'package:hr_app/core/network/network.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkHelper {
  NetworkHelper._();

  static Future<Dio> createDio() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppFlavor.instance.environment.baseUrl,
        followRedirects: true,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger());
    }
    dio.interceptors.add(CustomInterceptor());

    dio.httpClientAdapter = await _setupProxy();

    return dio;
  }

  static Future<ad.IOHttpClientAdapter> _setupProxy() async {
    final proxyConfig = await SecureStorage().getProxyConfig();

    // SSL & proxy config
    return ad.IOHttpClientAdapter(
      createHttpClient: () {
        final client = io.HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;

        // Async proxy setup workaround
        if (proxyConfig.isProxyEnabled) {
          client.findProxy =
              (uri) => "PROXY ${proxyConfig.host}:${proxyConfig.port}";
        }

        return client;
      },
      validateCertificate: (cert, host, port) => true,
    );
  }
}
