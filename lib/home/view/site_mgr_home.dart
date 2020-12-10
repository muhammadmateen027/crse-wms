import 'package:crsewms/home/mrfs/mrfs.dart';
import 'package:crsewms/home/order/order-list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SiteManagerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MRF List'),
        actions: [
          ReloadMrfs(),
          LogoutButton(),
        ],
      ),
      body: MRFListView(),
    );
  }
}