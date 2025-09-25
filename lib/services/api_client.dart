import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Categorized error for API operations.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Uri? uri;
  final Object? inner;

  ApiException(this.message, {this.statusCode, this.uri, this.inner});

  @override
  String toString() {
    final code = statusCode != null ? ' (status: $statusCode)' : '';
    final url = uri != null ? ' [${uri.toString()}]' : '';
    return 'ApiException: $message$code$url';
  }
}

/// Lightweight API client with timeouts, retries, and logging.
class ApiClient {
  final http.Client _client;
  final Duration requestTimeout;
  final int maxRetries;

  ApiClient({
    http.Client? client,
    this.requestTimeout = const Duration(seconds: 12),
    this.maxRetries = 2,
  }) : _client = client ?? http.Client();

  Future<http.StreamedResponse> sendMultipart({
    required Uri uri,
    required String method,
    Map<String, String>? headers,
    List<http.MultipartFile> files = const [],
    Map<String, String> fields = const {},
  }) async {
    final request = http.MultipartRequest(method, uri);
    if (headers != null) request.headers.addAll(headers);
    request.fields.addAll(fields);
    request.files.addAll(files);

    return _retry(() async {
      final startedAt = DateTime.now();
      if (kDebugMode) {
        debugPrint('[API] -> $method $uri');
      }
      try {
        final response = await _client
            .send(request)
            .timeout(requestTimeout);
        if (kDebugMode) {
          debugPrint('[API] <- ${response.statusCode} ${DateTime.now().difference(startedAt).inMilliseconds}ms');
        }
        return response;
      } on TimeoutException catch (e) {
        throw ApiException('Request timed out', uri: uri, inner: e);
      } on SocketException catch (e) {
        throw ApiException('Network unavailable', uri: uri, inner: e);
      } on HttpException catch (e) {
        throw ApiException('HTTP error', uri: uri, inner: e);
      }
    });
  }

  Future<T> decodeJsonBody<T>(http.StreamedResponse response) async {
    final bodyString = await response.stream.bytesToString();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Server responded with ${response.statusCode}',
        statusCode: response.statusCode,
        inner: bodyString,
      );
    }
    try {
      final decoded = jsonDecode(bodyString);
      return decoded as T;
    } catch (e) {
      throw ApiException('Invalid JSON response', inner: bodyString);
    }
  }

  Future<R> _retry<R>(Future<R> Function() action) async {
    int attempt = 0;
    Object? lastError;
    while (attempt <= maxRetries) {
      try {
        return await action();
      } catch (e) {
        lastError = e;
        final isLast = attempt == maxRetries;
        if (isLast || !_isRetriableError(e)) {
          rethrow;
        }
        // Exponential backoff with jitter
        final delayMs = (200 * (1 << attempt)) + (DateTime.now().millisecondsSinceEpoch % 150);
        await Future.delayed(Duration(milliseconds: delayMs));
        attempt += 1;
      }
    }
    throw ApiException('Request failed after retries', inner: lastError);
  }

  bool _isRetriableError(Object error) {
    if (error is TimeoutException) return true;
    if (error is SocketException) return true;
    if (error is ApiException && (error.statusCode == null || error.statusCode! >= 500)) return true;
    return false;
  }

  void close() {
    _client.close();
  }
}




