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

    if (event is SearchMRFEvent) {
      yield* _searchMrfListToState(event);
    }
  }

  Stream<MrfListState> _searchMrfListToState(SearchMRFEvent event) async* {
    yield MrfLoadState(mrfList: []);

    try {
      Map map = {'search': event.query};
      map.addAll(await _getToken());

      Response response = await userRepositoryInterface.loadMrfList(map);

      MRFs mrFs = MRFs.fromJson(response.data);
      if (mrFs.mrfList.length == 0) {
        yield EmptyMrfListState();
        return;
      }

      yield MrfLoadState(mrfList: mrFs.mrfList);
      return;
    } on ApiException catch (error) {
      yield MrfListFailure(error: error.toString());
      return;
    }
  }

  Stream<MrfListState> _getMrfListToState(FetchMRFs event) async* {
    yield MrfListLoading();

    try {
      Response response =
          await userRepositoryInterface.loadMrfList(await _getToken());

      MRFs mrFs = MRFs.fromJson(response.data);
      if (mrFs.mrfList.length == 0) {
        yield EmptyMrfListState();
        return;
      }

      yield MrfLoadState(
        mrfList: _getSpecificMrfList(event.isApprovedMrf, mrFs.mrfList),
      );
      return;
    } on ApiException catch (error) {
      yield MrfListFailure(error: error.toString());
      return;
    }
  }

  List<MrfData> _getSpecificMrfList(bool isApprovedMrf, List<MrfData> mrfList) {
    List<MrfData> list = [];
    if (!isApprovedMrf) {
      for (int index = 0; index < mrfList.length; index++) {
        if (mrfList[index].reqStatus == 0) {
          list.add(mrfList[index]);
        }
      }
      return list;
    }

    for (int index = 0; index < mrfList.length; index++) {
      if (mrfList[index].reqStatus == 3) {
        list.add(mrfList[index]);
      }
    }

    return list;
  }

  Future<Map> _getToken() async {
    Map map = new Map();
    String user =
        await userRepositoryInterface.retrieveToken(DotEnv().env['TOKEN']);
    map = {'email': user.split('::')[0], 'password': user.split('::')[1]};

    return map;
  }
}
