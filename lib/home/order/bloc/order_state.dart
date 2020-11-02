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
  const OrdersFetchedState({@required this.orders});
  @override
  List<Object> get props => [orders];
}
class NoOrderListState extends OrderState {}

class OrderUpdatedState extends OrderState {}


class OrderDetailState extends OrderState {
  final OrderDetail orderDetail;
  const OrderDetailState({@required this.orderDetail});
  @override
  List<Object> get props => [orderDetail];
}