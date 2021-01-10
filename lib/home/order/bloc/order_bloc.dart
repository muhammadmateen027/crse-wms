import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
    if (event is UpdateOrderStatus) {
      yield* _updateOrderStatus(event);
    }

    if (event is SearchOrderEvent) {
      yield* _searchOrderToState(event);
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
    List<OrderItem> orders = [];

    for (int index = 0; index < orderList.orders.length; index++) {
      if (orderList.orders[index].reqStatus == 5 && event.isOrderDelivered) {
        orders.add(orderList.orders[index]);
      } else if (orderList.orders[index].reqStatus == 3 &&
          !event.isOrderDelivered) {
        orders.add(orderList.orders[index]);
      }
    }

    if (orders.length == 0) {
      yield NoOrderListState();
      return;
    }

    yield OrdersFetchedState(orders: orders, isSearch: false);
    return;
  }

  Stream<OrderState> _fetchOrderDetailToState(FetchOrderDetail event) async* {
    yield OrderLoading();
    Response response;
    List list = event.arguments;
    Map map = {'req_id': list[0]};
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

  Stream<OrderState> _updateOrderStatus(UpdateOrderStatus event) async* {
    yield OrderLoading();
    Response response;
    List list = event.arguments;
    String base64Image = base64Encode(event.file.readAsBytesSync());
    Map map = {'req_id': list[0], 'status': '5', 'image': base64Image};
    map.addAll(await _getToken());

    try {
      response = await userRepositoryInterface.orderStatusUpdate(map);
    } on ApiException catch (error) {
      yield OrderFailure(error: error.toString());
      return;
    }

    yield OrderUpdatedState();
    return;
  }

  Stream<OrderState> _searchOrderToState(SearchOrderEvent event) async* {

    List<OrderItem> orders = [];

    if (event.orders.length == 0) {
      yield NoOrderListState();
      return;
    }

    for(int index=0; index < event.orders.length; index++) {
      if (event.orders[index].destinationAddress.contains(event.query) ||
          event.orders[index].destinationName.contains(event.query) ||
          event.orders[index].originAddress.contains(event.query) ||
          event.orders[index].project.contains(event.query) ||
          event.orders[index].desc.contains(event.query) ||
          event.orders[index].originState.contains(event.query) ||
          event.orders[index].destinationState.contains(event.query) ||
          event.orders[index].originName.contains(event.query) ||
          event.orders[index].document.contains(event.query) ||
          event.orders[index].originZip.contains(event.query) ||
          event.orders[index].destinationZip.contains(event.query)
      ) {
        orders.add(event.orders[index]);
      }
    }

    if (orders.length == 0) {
      yield NoOrderListState();
      return;
    }

    yield OrdersFetchedState(orders: orders, isSearch: true);
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
