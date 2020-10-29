import 'package:dio/dio.dart';

abstract class UserRepositoryInterface {
  Future<bool> hasToken(String key);
  Future<void> persistToken(String key, String value);
  Future<String> retrieveToken(String key);
  Future<void> deleteToken();

  Future<Response> login(String email, String password);

  Future<Response> orderList(Map data);
}