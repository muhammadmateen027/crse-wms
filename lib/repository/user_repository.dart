import 'package:flutter/foundation.dart';
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
    await Future.delayed(Duration(seconds: 1));
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
  Future<void> persistToken(String key, String value) async {
    return await storage.write(key: key, value: value);
  }
}