import 'package:dio/dio.dart';

class HttpError {
  static const int UNAUTHORIZED = 401;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;
  static const int REQUEST_TIMEOUT = 408;
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int BAD_GATEWAY = 502;
  static const int SERVICE_UNAVAILABLE = 503;
  static const int GATEWAY_TIMEOUT = 504;

  ///未知错误
  static const String UNKNOWN = "UNKNOWN";

  ///解析错误
  static const String PARSE_ERROR = "PARSE_ERROR";

  ///网络错误
  static const String NETWORK_ERROR = "NETWORK_ERROR";

  ///协议错误
  static const String HTTP_ERROR = "HTTP_ERROR";

  ///证书错误
  static const String SSL_ERROR = "SSL_ERROR";

  ///连接超时
  static const String CONNECT_TIMEOUT = "CONNECT_TIMEOUT";

  ///响应超时
  static const String RECEIVE_TIMEOUT = "RECEIVE_TIMEOUT";

  ///发送超时
  static const String SEND_TIMEOUT = "SEND_TIMEOUT";

  ///网络请求取消
  static const String CANCEL = "CANCEL";

  DioErrorType errorType = UNKNOWN as DioErrorType;

  String message = '';

  HttpError({required this.errorType, required this.message});

  HttpError.dioError(errorType) {
    switch (errorType) {
      case CONNECT_TIMEOUT:
        errorType = CONNECT_TIMEOUT;
        message =
            "The network connection timed out, please check the network settings!";
        break;
      case RECEIVE_TIMEOUT:
        errorType = RECEIVE_TIMEOUT;
        message = "The server is abnormal, please try again later!";
        break;
      case SEND_TIMEOUT:
        errorType = SEND_TIMEOUT;
        message =
            "The network connection timed out, please check the network settings!";
        break;
      case CANCEL:
        errorType = CANCEL;
        message = "The request has been cancelled, please request again!";
        break;
      default:
        errorType = UNKNOWN;
        message =
            "The network connection timed out, please check the network settings!";
        break;
    }
    print("HttpError.dioError::: $message");
    // showToast(message);
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'HttpError{code:$errorType , message:$message}';
  }
}
