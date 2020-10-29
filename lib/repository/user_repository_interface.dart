import 'package:dio/dio.dart';

abstract class UserRepositoryInterface {
  Future<bool> hasToken(String key);
  Future<void> persistToken(String key, String value);
  Future<void> deleteToken();

  Future<Response> login(String email, String password);
}