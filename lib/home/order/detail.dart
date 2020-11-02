import 'package:crsewms/repository/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes_name.dart';
import 'bloc/order_bloc.dart';

class OrderDetailPage extends StatefulWidget {
  final Object arguments;

  const OrderDetailPage({Key key, @required this.arguments}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String floatingActionLabel = 'Confirm Delivery';
  Color floatingButtonColor = Colors.green;
  List list = [];
  OrderDetail orderDetail;

  @override
  void initState() {
    context.bloc<OrderBloc>()
      ..add(
        FetchOrderDetail(arguments: widget.arguments),
      );
    list = widget.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xFFffa354).withOpacity(0.8),
        title: Text('Stock Detail', style: TextStyle(color: Colors.black)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: list[1] == 5
            ? null
            : () {
                final result = Navigator.of(context).pushNamed(
                  RoutesName.deliver,
                  arguments: widget.arguments,
                );
                context.bloc<OrderBloc>()
                  ..add(
                    FetchOrderDetail(arguments: widget.arguments),
                  );
              },
        icon: Icon(Icons.local_shipping),
        label: Text(list[1] == 5 ? 'Delivered' : 'Confirm Delivery'),
        backgroundColor: list[1] == 5 ? Colors.grey : Colors.green,
      ),
      body: Container(
        color: Colors.white,
        child: BlocListener<OrderBloc, OrderState>(
          listener: (_, state) {
            if (state is OrderDetailState) {
              setState(() {
                orderDetail = state.orderDetail;
              });
            }
          },
          child: orderDetail != null ?  ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getOrderDetail(orderDetail),
              _getStockList(orderDetail.stocks),
            ],
          ) :  Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFff8b54)),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getStockList(List<Stock> stocks) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      width: double.maxFinite,
      child: ListView.separated(
        padding: EdgeInsets.only(top: 8.0),
        itemCount: stocks.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (_, index) => SizedBox(
          height: 8.0,
          child: Divider(),
        ),
        itemBuilder: (_, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Color(0xFFff8b54)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  stocks[index].iname,
                  style: TextStyle(
                    color: Color(0xFFff8b54),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                _listItemLabelView('Comment', stocks[index].comment),
                SizedBox(height: 4.0),
                _listItemLabelView('Category', stocks[index].category),
                SizedBox(height: 4.0),
                _listItemLabelView('Unit', stocks[index].unit),
                SizedBox(height: 4.0),
                _listItemLabelView('Approved Quantity', stocks[index].appQty),
                SizedBox(height: 4.0),
                _listItemLabelView(
                    'Approved Comment', stocks[index].appComment),
                SizedBox(height: 4.0),
                _listItemLabelView('Date', stocks[index].formatDateTime()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getOrderDetail(OrderDetail orderDetail) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            orderDetail.project,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.0),
          _detailLabelView('Document', orderDetail.document),
          SizedBox(height: 4.0),
          _detailLabelView('Created By', orderDetail.createBy),
          SizedBox(height: 4.0),
          _detailLabelView(
            'Origin',
            '${orderDetail.originName},'
                ' ${orderDetail.originAddress}, '
                '${orderDetail.originState}',
          ),
          SizedBox(height: 4.0),
          _detailLabelView(
            'Destination',
            '${orderDetail.destinationName}, '
                '${orderDetail.destinationAddress},'
                ' ${orderDetail.destinationState}',
          ),
          SizedBox(height: 4.0),
          _detailLabelView(
            'CreatedAt',
            orderDetail.formatDateTime(),
          ),
        ],
      ),
    );
  }

  Widget _detailLabelView(String label, String text) {
    return RichText(
      text: TextSpan(
        text: '$label: ',
        style: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
        children: <TextSpan>[
          TextSpan(
            text: text,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listItemLabelView(String label, String text) {
    return RichText(
      text: TextSpan(
        text: '$label: ',
        style: TextStyle(
          color: Colors.grey,
        ),
        children: <TextSpan>[
          TextSpan(
            text: text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
