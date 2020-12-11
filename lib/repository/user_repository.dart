import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'data_provider/data_provider.dart';
import 'user_repository_interface.dart';

class UserRepository implements UserRepositoryInterface {
  final DataProviderClient dataProviderClient;
  final FlutterSecureStorage storage;

  UserRepository({@required this.dataProviderClient, @required this.storage})
      : assert(dataProviderClient != null),
        assert(storage != null);

  @override
  Future<void> deleteToken() async {
    await storage.deleteAll();
    return;
  }

  @override
  Future<bool> hasToken(String key) async {
    await Future.delayed(Duration(seconds: 2));
    try {
      String token = await storage.read(key: key) ?? null;
      if (token != null) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String> retrieveToken(String key) async {
    return await storage.read(key: key) ?? null;
  }

  @override
  Future<void> persistToken(String key, String value) async {
    return await storage.write(key: key, value: value);
  }

  @override
  Future<Response> login(String email, String password) async {
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/login',
      '',
      data: {'email': email, 'password': password},
    );
  }

  @override
  Future<Response> orderList(Map data) async {
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/list',
      '',
      data: data,
    );
  }

  @override
  Future<Response> orderDetail(Map data) async {
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/stocklist',
      '',
      data: data,
    );
  }

  @override
  Future<Response> orderStatusUpdate(Map data) async {
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/update',
      '',
      data: data,
    );
  }

  @override
  Future<Response> loadMrfList(Map data) async {
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/mrf',
      '',
      data: data,
    );
  }

  @override
  Future<Response> boqList(Map data) async {
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/list-boq',
      '',
      data: data,
    );
  }

  @override
  Future<Response> deleteMrf(Map data) async {
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/mrf-delete',
      '',
      data: data,
    );
  }

  @override
  Future<Response> locationList(Map data) async{
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/list-location',
      '',
      data: data,
    );
  }

  @override
  Future<Response> saveMrf(Map data) async{
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/mrf-create',
      '',
      data: data,
    );
  }

  @override
  Future<Response> mrfStockDetail(Map data) async{
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/mrf-stock',
      '',
      data: data,
    );
  }

  @override
  Future<Response> listStock(Map data) async{
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/list-stock',
      '',
      data: data,
    );
  }

  @override
  Future<Response> saveStockToMrf(Map data) async{
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/mrf-stock-create',
      '',
      data: data,
    );
  }

  @override
  Future<Response> deleteStockFromMrf(Map data) async{
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/mrf-stock-delete',
      '',
      data: data,
    );
  }

  @override
  Future<Response> updateMrf(Map data) async{
    return await dataProviderClient.post(
      '${DotEnv().env['API_URL']}/mrf-update',
      '',
      data: data,
    );
  }

}