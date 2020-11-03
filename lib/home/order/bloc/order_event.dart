part of 'order_bloc.dart';

@immutable
abstract class OrderEvent {
  const OrderEvent();

  List<Object> get props => [];
}

class FetchOrders extends OrderEvent{
  final bool isOrderDelivered;
  const FetchOrders({@required this.isOrderDelivered});
  @override
  List<Object> get props => [isOrderDelivered];
}

class FetchOrderDetail extends OrderEvent{
  final Object arguments;
  const FetchOrderDetail({@required this.arguments});
  @override
  List<Object> get props => [arguments];
}

class UpdateOrderStatus extends OrderEvent{
  final Object arguments;
  final File file;
  const UpdateOrderStatus({@required this.arguments, @required this.file});
  @override
  List<Object> get props => [arguments, file];
}
