import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:dio/io.dart' as ad;
import 'package:flutter/foundation.dart';
import 'package:idara_esign/config/env/app_config.dart';
import 'package:idara_esign/core/networking/networking.dart';
import 'package:idara_esign/core/security/secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Helper class for creating and configuring Dio instances
class NetworkHelper {
  final AppConfig _config;
  final SecureStorage _secureStorage;

  NetworkHelper(this._config, this._secureStorage);

  Future<Dio> createDio({
    int defaultMaxRetries = 3,
    Duration defaultRetryDelay = const Duration(seconds: 2),
  }) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: _config.apiBaseUrl,
        followRedirects: true,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    // Add interceptors in order
    dio.interceptors.addAll([
      CustomInterceptor(secureStorage: _secureStorage),
      RetryInterceptor(
        dio: dio,
        maxRetries: defaultMaxRetries,
        initialDelay: defaultRetryDelay,
      ),
      if (kDebugMode) PrettyDioLogger(),
    ]);

    if (!kIsWeb) {
      dio.httpClientAdapter = _setupProxy();
    }

    return dio;
  }

  /// Configures HTTP client adapter with SSL settings
  ad.IOHttpClientAdapter _setupProxy() {
    return ad.IOHttpClientAdapter(
      createHttpClient: () {
        final client = io.HttpClient();
        // Allow self-signed certificates in development
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
      validateCertificate: (cert, host, port) => true,
    );
  }
}
