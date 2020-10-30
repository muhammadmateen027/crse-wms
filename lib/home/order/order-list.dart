import 'package:crsewms/authentication/view/view.dart';
import 'package:crsewms/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes_name.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  void initState() {
    context.bloc<OrderBloc>()..add(FetchOrders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFffa354).withOpacity(0.8),
        title: Text(
          'Orders',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              context.bloc<OrderBloc>()..add(FetchOrders());
            },
          )
        ],
      ),
      body: AppBackgroundContainer(
        height: double.maxFinite,
        width: double.maxFinite,
        alignment: Alignment.topCenter,
        child: Container(
          color: Colors.white.withOpacity(0.4),
          width: double.maxFinite,
          height: double.maxFinite,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocConsumer<OrderBloc, OrderState>(
            listener: (_, state) {},
            builder: (_, state) {
              if (state is NoOrderListState) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Order is not available.',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                );
              }
              if (state is OrdersFetchedState) {
                return ListView.separated(
                  padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                  separatorBuilder: (_, index) => SizedBox(
                    height: 8.0,
                    child: Divider(),
                  ),
                  itemCount: state.orders.length,
                  itemBuilder: (_, index) {
                    return OrderItemWidget(
                      orderItem: state.orders[index],
                      onTap: () async {
                        await Navigator.of(context).pushNamed(
                          RoutesName.detail,
                          arguments: [
                            state.orders[index].reqId,
                            state.orders[index].reqStatus
                          ],
                        );
                        context.bloc<OrderBloc>()..add(FetchOrders());
                      },
                    );
                  },
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFff8b54)),
                  backgroundColor: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
