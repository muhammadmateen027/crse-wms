import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crsewms/repository/model/model.dart';
import 'package:crsewms/repository/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({
    @required this.userRepositoryInterface,
  })  : assert(userRepositoryInterface != null),
        super(OrderInitial());

  final UserRepositoryInterface userRepositoryInterface;

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if (event is FetchOrders) {
      yield* _fetchOrdersToState(event);
      return;
    }
    if (event is FetchOrderDetail) {
      yield* _fetchOrderDetailToState(event);
      return;
    }
  }

  Stream<OrderState> _fetchOrdersToState(FetchOrders event) async* {
    yield OrderLoading();
    Response response;

    try {
      response = await userRepositoryInterface.orderList(await _getToken());
    } on ApiException catch (error) {
      yield OrderFailure(error: error.toString());
      return;
    }

    OrderList orderList = OrderList.fromJson(response.data);
    if (orderList.orders.length == 0) {
      yield NoOrderListState();
      return;
    }

    yield OrdersFetchedState(orders: orderList.orders);
    return;
  }

  Stream<OrderState> _fetchOrderDetailToState(FetchOrderDetail event) async* {
    yield OrderLoading();
    Response response;
    List list = event.arguments;
    Map map = {
      'req_id': list[0],
      'status': list[1],
    };
    map.addAll(await _getToken());

    try {
      response = await userRepositoryInterface.orderDetail(map);
    } on ApiException catch (error) {
      yield OrderFailure(error: error.toString());
      return;
    }

    OrderDetail orderDetail = OrderDetail.fromJson(response.data);

    yield OrderDetailState(orderDetail: orderDetail);
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
