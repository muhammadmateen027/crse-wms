import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crsewms/repository/model/mrfs/boq_list.dart';
import 'package:crsewms/repository/model/mrfs/location_list.dart';
import 'package:crsewms/repository/model/mrfs/stock_detail.dart';
import 'package:crsewms/repository/model/mrfs/stocks.dart';
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

    if (event is GetStockDetailEvent) {
      yield* _getStockDetailToState(event.id);
    }

    if (event is FetchStockList) {
      yield* _getStockListToState(event);
    }
    if (event is AddStockToMrf) {
      yield* _saveStockToMrfToState(event);
    }
    if (event is DeleteStockEvent) {
      yield* _deleteStockToState(event);
    }
    if (event is UpdateMrfEvent){
      yield* _updateMrfToState(event);
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
  Stream<MrfCrudState> _deleteStockToState(DeleteStockEvent event) async* {
    yield MrfCrudLoading();
    Response response;
    Map data = {'reqstock_id': event.stockId};
    data.addAll(await _getToken());
    try {
      response = await userRepositoryInterface.deleteStockFromMrf(data);
    } on ApiException catch (error) {
      yield MrfCrudFailure(error: error.toString());
      return;
    }

    yield* _getStockDetailToState(event.reqId);
    return;
  }

  Stream<MrfCrudState> _getStockDetailToState(
      String id) async* {
    yield MrfCrudLoading();
    Response response;
    Map data = {'req_id': id};
    data.addAll(await _getToken());
    try {
      response = await userRepositoryInterface.mrfStockDetail(data);
    } on ApiException catch (error) {
      yield MrfCrudFailure(error: error.toString());
      return;
    }

    StockDetail stockDetail = StockDetail.fromJson(response.data);
    yield StockDetailLoadedState(stockDetail: stockDetail);
    return;
  }

  Stream<MrfCrudState> _saveStockToMrfToState(AddStockToMrf event) async* {
    yield MrfCrudLoading();
    Response response;
    Map data = {
      'req_id': event.id,
      'stock_id': event.stockId,
      'req_qty': event.quantity,
      'remarks': event.remarks,
    };
    data.addAll(await _getToken());
    try {
      response = await userRepositoryInterface.saveStockToMrf(data);
    } on ApiException catch (error) {
      yield MrfCrudFailure(error: error.toString());
      return;
    }


    yield StockSavedSuccessState();
    return;
  }

  Stream<MrfCrudState> _getStockListToState(FetchStockList event) async* {
    yield MrfCrudLoading();
    Response response;
    try {
      response = await userRepositoryInterface.listStock(await _getToken());
    } on ApiException catch (error) {
      yield MrfCrudFailure(error: error.toString());
      return;
    }

    Stocks stocks = Stocks.fromJson(response.data);
    yield StockListLoaded(stockList: stocks.stockList);
    return;
  }

  Stream<MrfCrudState> _saveMrfToState(SaveMrfEvent event) async* {
    yield MrfCrudLoading();
    Response response;
    Map data = {
      'boq_id': event.boq.id,
      'stock_location': event.pickupLocation.id,
      'delivery_location': event.dropOffLocation.id,
      'description': event.description,
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

  Stream<MrfCrudState> _updateMrfToState(UpdateMrfEvent event) async* {
    yield MrfCrudLoading();
    Response response;
    Map data = {
      'req_id': event.reqId,
      'stock_location': event.pickupLocation.id,
      'delivery_location': event.dropOffLocation.id,
      'description': event.description,
    };
    data.addAll(await _getToken());
    try {
      response = await userRepositoryInterface.updateMrf(data);
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
