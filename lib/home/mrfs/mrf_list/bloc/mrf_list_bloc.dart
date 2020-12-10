import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crsewms/repository/model/mrfs/mrf_list.dart';
import 'package:crsewms/repository/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';

part 'mrf_list_event.dart';

part 'mrf_list_state.dart';

class MrfListBloc extends Bloc<MrfListEvent, MrfListState> {
  MrfListBloc({
    @required this.userRepositoryInterface,
  })  : assert(userRepositoryInterface != null),
        super(MrfListInitial());

  final UserRepositoryInterface userRepositoryInterface;

  @override
  Stream<MrfListState> mapEventToState(MrfListEvent event) async* {
    if (event is FetchMRFs) {
      yield* _getMrfListToState(event);
    }
  }

  Stream<MrfListState> _getMrfListToState(FetchMRFs event) async*{
    yield MrfListLoading();
    Response response;
    try {
      response = await userRepositoryInterface.loadMrfList(await _getToken());
    } on ApiException catch (error) {
    yield MrfListFailure(error: error.toString());
    return;
    }

    MRFs mrFs = MRFs.fromJson(response.data);
    yield MrfLoadState(mrfList: mrFs.mrfList);
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
