import 'dart:io';

import 'package:crsewms/authentication/authentication.dart';
import 'package:crsewms/home/home.dart';
import 'package:crsewms/repository/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes_name.dart';

class OrderList extends StatefulWidget {
  const OrderList({
    Key key,
    @required this.isOrderDelivered,
    @required this.label,
  }) : super(key: key);
  final bool isOrderDelivered;
  final String label;

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final ScrollController _scrollController = ScrollController();
  List<OrderItem> orders = [];
  List<OrderItem> listOrders = [];

  @override
  void initState() {
    context.bloc<OrderBloc>()
      ..add(
        FetchOrders(isOrderDelivered: widget.isOrderDelivered),
      );
    super.initState();
    _scrollController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.bloc<OrderBloc>()..add(ScanOrder());
        },
        child: Icon(Icons.center_focus_weak),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _getSearchField(),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Container(
                color: Colors.white.withOpacity(0.4),
                width: double.maxFinite,
                height: double.maxFinite,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocConsumer<OrderBloc, OrderState>(
                  listener: (_, state) {
                    if (state is OrdersFetchedState) {
                      if (!state.isSearch) {
                        setState(() {
                          this.orders = state.orders;
                        });
                        return;
                      }
                    }

                    if (state is ScannedFetchedState) {
                      _pushToDetailPage(state.reqId, state.reqStatus);
                    }
                  },
                  builder: (_, state) {
                    if (state is NoOrderListState) {
                      return Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 2,
                        width: double.maxFinite,
                        child: Text(
                          'Order is not available.',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      );
                    }
                    if (state is OrdersFetchedState) {
                      return ListView.separated(
                        padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                        separatorBuilder: (_, index) => Divider(
                          color: Theme.of(context).primaryColor,
                        ),
                        itemCount: state.orders.length,
                        itemBuilder: (_, index) {
                          return OrderItemWidget(
                            orderItem: state.orders[index],
                            onTap: () async {
                              _pushToDetailPage(
                                state.orders[index].reqId,
                                state.orders[index].reqStatus,
                              );
                            },
                          );
                        },
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFff8b54)),
                        backgroundColor: Colors.white,
                      ),
                    );
                  },
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

  void _pushToDetailPage(int reqId, int reqStatus) async {
    await Navigator.of(context).pushNamed(
      RoutesName.detail,
      arguments: [reqId, reqStatus],
    );
    context.bloc<OrderBloc>()
      ..add(
        FetchOrders(
          isOrderDelivered: widget.isOrderDelivered,
        ),
      );
  }

  Widget _getSearchField() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: false,
      stretch: true,
      centerTitle: Platform.isIOS,
      expandedHeight: 100,
      title: Text('Available hubs'),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.black),
          onPressed: () {
            context.bloc<OrderBloc>()
              ..add(
                FetchOrders(
                  isOrderDelivered: widget.isOrderDelivered,
                ),
              );
          },
        ),
        LogoutButton(),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
        background: Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              color: Colors.white,
              border: Border.all(color: Colors.white),
            ),
            padding: EdgeInsets.only(left: 8.0),
            child: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.headline6,
              decoration: InputDecoration(
                hintStyle: Theme.of(context).textTheme.caption,
                border: InputBorder.none,
                hintText: 'Search here...',
                suffixIcon: Icon(Icons.search),
              ),
              autovalidate: true,
              onChanged: (query) {
                context.bloc<OrderBloc>()
                  ..add(
                    SearchOrderEvent(orders: orders, query: query),
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (_, state) {
        if (state is AuthenticationUnAuthenticated) {
          Navigator.of(context).pushReplacementNamed(RoutesName.login);
        }
      },
      child: IconButton(
        icon: Icon(Icons.screen_lock_portrait, color: Colors.black87),
        onPressed: () {
          context.bloc<AuthenticationBloc>()..add(UnAuthenticate());
        },
      ),
    );
  }
}
