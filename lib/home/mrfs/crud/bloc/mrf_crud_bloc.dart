import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crsewms/repository/model/mrfs/boq_list.dart';
import 'package:crsewms/repository/model/mrfs/location_list.dart';
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

    if (event is FetchBOQ) {
      yield* _fetchBoqToState(event);
    }

    if (event is FetchLocation) {
      yield* _fetchLocationToState(event);
    }

    if (event is SaveMrfEvent) {
      yield* _saveMrfToState(event);
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

  Stream<MrfCrudState> _saveMrfToState(SaveMrfEvent event) async* {
    yield MrfCrudLoading();
    Response response;
    Map data = {
      'boq_id': event.boq.id,
      'stock_location': event.pickupLocation.id,
      'delivery_location': event.dropOffLocation.id,
      'description': event.comment,
    };
    data.addAll(await _getToken());
    try {
      response = await userRepositoryInterface.saveMrf(data);
    } on ApiException catch (error) {
      yield MrfCrudFailure(error: error.toString());
      return;
    }

    yield MRFSavedState();
    return;
  }

  Stream<MrfCrudState> _fetchBoqToState(FetchBOQ event) async* {
    yield MrfCrudLoading();
    Response response;

    try {
      response = await userRepositoryInterface.boqList(await _getToken());
    } on ApiException catch (error) {
      yield MrfCrudFailure(error: error.toString());
      return;
    }

    BoqList boqList = BoqList.fromJson(response.data);
    yield BoqLoaded(boqs: boqList.boqs);
    return;
  }

  Stream<MrfCrudState> _fetchLocationToState(FetchLocation event) async* {
    yield MrfCrudLoading();
    Response response;

    try {
      response = await userRepositoryInterface.locationList(await _getToken());
    } on ApiException catch (error) {
      yield MrfCrudFailure(error: error.toString());
      return;
    }

    LocationList locationList = LocationList.fromJson(response.data);
    yield LocationLoaded(locations: locationList.locations);
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
