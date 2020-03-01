import 'package:dio/dio.dart';

class NetUtil {
  Dio _dio;

  factory NetUtil() => _getInstance();

  static NetUtil get instance => _getInstance();

  static NetUtil _instance;

  static NetUtil _getInstance() {
    if (_instance == null) {
      _instance = NetUtil._init();
    }
    return _instance;
  }

  NetUtil._init() {
    _dio = Dio();
  }

  Future<Map<String, dynamic>> get(String url, Map<String, dynamic> params) async {
    if (url != null && params != null && params.isNotEmpty) {
      var response = await _dio.get(url, queryParameters: params);
      return response.data;
    }
    return null;
  }

  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> params) async {
    if (url != null && params != null && params.isNotEmpty) {
      var response = await _dio.post(url, data: params);
      return response.data;
    }
    return null;
  }
}
