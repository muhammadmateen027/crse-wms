import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crsewms/repository/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';

part 'mrf_crud_event.dart';

part 'mrf_crud_state.dart';

class MrfCrudBloc extends Bloc<MrfCrudEvent, MrfCrudState> {
  MrfCrudBloc({@required this.userRepositoryInterface})
      : assert(userRepositoryInterface != null),
        super(MrfCrudInitial());

  final UserRepositoryInterface userRepositoryInterface;

  @override
  Stream<MrfCrudState> mapEventToState(MrfCrudEvent event) async* {
    if (event is DeleteMrfEvent) {
      yield* _deleteMrfToState(event);
    }
  }

  Stream<MrfCrudState> _deleteMrfToState(DeleteMrfEvent event) async* {
    yield MrfCrudLoading();
    Response response;
    Map data = {'req_id': event.mrfId};
    data.addAll(await _getToken());
    try {
      response = await userRepositoryInterface.deleteMrf(data);
    } on ApiException catch (error) {
      yield MrfCrudFailure(error: error.toString());
      return;
    }

    yield MrfDeleteSuccess();
    return;
  }

  Future<Map> _getToken() async {
    Map map = new Map();
    String user =
        await userRepositoryInterface.retrieveToken(DotEnv().env['TOKEN']);
    map = {'email': user.split('::')[0], 'password': user.split('::')[1]};

    return map;
  }
}
