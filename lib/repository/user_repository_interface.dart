import 'package:dio/dio.dart';

abstract class UserRepositoryInterface {
  Future<bool> hasToken(String key);
  Future<void> persistToken(String key, String value);
  Future<String> retrieveToken(String key);
  Future<void> deleteToken();

  Future<Response> login(String email, String password);

  Future<Response> scanOrder(Map data);
  Future<Response> orderList(Map data);
  Future<Response> orderDetail(Map data);
  Future<Response> orderStatusUpdate(Map data);


  Future<Response> loadMrfList(Map data);
  Future<Response> deleteMrf(Map data);
  Future<Response> boqList(Map data);
  Future<Response> locationList(Map data);
  Future<Response> mrfScan(Map data);

  Future<Response> saveMrf(Map data);
  Future<Response> updateMrf(Map data);

  Future<Response> mrfStockDetail(Map data);

  Future<Response> listStock(Map data);

  Future<Response> saveStockToMrf(Map data);
  Future<Response> deleteStockFromMrf(Map data);
}