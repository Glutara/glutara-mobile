import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio = Dio();

  Future<Response> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        'http://10.0.2.2:8000/api/auth/login',
        data: {'Email': email, 'Password': password},
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
