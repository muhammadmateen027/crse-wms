import 'package:crsewms/repository/model/model.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({
    Key key,
    @required this.orderItem,
    @required this.onTap,
  }) : super(key: key);
  final OrderItem orderItem;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.maxFinite,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8.0,
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        title: getTitle(orderItem),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              orderItem.document,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                text: 'Created By: ',
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: orderItem.createBy,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                text: 'Origin: ',
                style: TextStyle(
                  color: Colors.grey,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: orderItem.originName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTitle(OrderItem orderItem) {
    String status;
    int color = 0xFFff8b54;
    if (orderItem.reqStatus == 3) {
      color = 0xFFff8b54;
      status = 'Pending';
    } else if (orderItem.reqStatus == 5) {
      status = 'Delivered';
      color = 0xFF009933;
    } else {
      status = 'Unknown';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 5,
          child: Text(
            orderItem.project,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                flex: 1,
                child: orderStatus(orderItem.reqStatus),
              ),
              SizedBox(width: 2.0),
              Flexible(
                flex: 4,
                child: Text(
                  status,
                  style: TextStyle(
                    color: Color(color),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Stack orderStatus(int reqStatus) {
    int color = 0xFFff8b54;
    IconData icon;
    if (reqStatus == 3) {
      color = 0xFFff8b54;
      icon = Icons.timer;
    } else {
      color = 0xFF009933;
      icon = Icons.check;
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: 16.0,
          width: 16.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Color(color),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 12.0,
          ),
        ), //local_offer
      ],
    );
  }
}
