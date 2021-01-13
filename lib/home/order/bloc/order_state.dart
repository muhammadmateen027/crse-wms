part of 'order_bloc.dart';

@immutable
abstract class OrderState {
  const OrderState();

  List<Object> get props => [];
}

class OrderInitial extends OrderState {}
class OrderLoading extends OrderState {}

class OrderFailure extends OrderState {
  final String error;
  const OrderFailure({@required this.error});
  @override
  List<Object> get props => [error];
}

class OrdersFetchedState extends OrderState {
  final List<OrderItem> orders;
  final bool isSearch;
  const OrdersFetchedState({@required this.orders,@required this.isSearch});
  @override
  List<Object> get props => [orders, isSearch];
}

class ScannedFetchedState extends OrderState {
  final int reqId;
  final int reqStatus;
  const ScannedFetchedState({@required this.reqId, @required this.reqStatus});
  @override
  List<Object> get props => [reqId, reqStatus];
}

class NoOrderListState extends OrderState {}

class OrderUpdatedState extends OrderState {}


class OrderDetailState extends OrderState {
  final OrderDetail orderDetail;
  const OrderDetailState({@required this.orderDetail});
  @override
  List<Object> get props => [orderDetail];
}