import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class HttpUtil {
  static late HttpUtil _instance;

  Dio? _dio;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  HttpUtil._internal() {
    BaseOptions options = BaseOptions(
      validateStatus:(status) => status != null && status < 500,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      responseType: ResponseType.json,
    );

    _dio = Dio(options);
    _dio!.interceptors.add(CookieManager(CookieJar()));
    _dio!.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers.addAll({
        HttpHeaders.contentTypeHeader: 'application/json',
        'antplatform': Platform.isIOS ? 'ios' : 'android',
      });

      return handler.next(options);
    }));
  }

  static HttpUtil _getInstance() {
    _instance = HttpUtil._internal();
    return _instance;
  }

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory HttpUtil.getInstance() => _getInstance();

  Future<Response> get(String url,
      {Map<String, dynamic>? parameters,
      Map<String, dynamic>? headers,
      int cacheHours = 0}) async {
    late Response resp;
    
    try {
      resp = await _dio!.get(url,
          queryParameters: parameters, options: Options(headers: headers));
    } catch (e) {
      print("gttp.get ERR: ${e.toString()}");
      return Future.error(e);
    }

    return resp;
  }

  Future<Response> post(String url,
      {dynamic data, Map<String, dynamic>? headers}) async {
    Options options = Options();
    options.headers = headers;
    try {
      return await _dio!.post(url, data: data, options: options);
    } catch (e) {
      print("ttp.post: ${e.toString()}");
      return Future.error(e);
    }
  }

  Future<Response> put(String url,
      {Map<String, dynamic>? headers, dynamic data}) async {
    Options options = Options();
    options.headers = headers;

    try {
      return await _dio!.put(url, data: data, options: options);
    } catch (e) {
      print("doHttpPut: ${e.toString()}");
      return Future.error(e);
    }
  }
}
