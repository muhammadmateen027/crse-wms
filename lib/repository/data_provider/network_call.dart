import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'api_exception.dart';

class DataProviderClient {
  final Dio dio;

  DataProviderClient({@required this.dio}) : assert(dio != null);

  void setDioOptions(String token) {
    dio.options.contentType = Headers.jsonContentType;
    dio.options.headers['Authorization'] =
        (token?.isEmpty ?? true) ? '' : 'Bearer $token';
  }

  Future<Response> get(
    String url,
    String token, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    this.setDioOptions(token);

    try {
      return await dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (error) {
      throw ApiException(error);
    }
  }

  Future<Response> post(
    String url,
    String token, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    this.setDioOptions(token);

    try {
      return await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (error) {
      throw ApiException(error);
    }
  }

  Future<Response> patch(
    String url,
    String token, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    this.setDioOptions(token);

    try {
      return await dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (error) {
      throw ApiException(error);
    }
  }

  Future<Response> put(
    String url,
    String token, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    this.setDioOptions(token);

    try {
      return await dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (error) {
      throw ApiException(error);
    }
  }
}
