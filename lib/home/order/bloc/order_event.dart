part of 'order_bloc.dart';

@immutable
abstract class OrderEvent {
  const OrderEvent();

  List<Object> get props => [];
}

class FetchOrders extends OrderEvent{}
