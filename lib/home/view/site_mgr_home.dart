import 'package:crsewms/home/mrfs/crud/crud.dart';
import 'package:crsewms/home/mrfs/mrfs.dart';
import 'package:crsewms/home/order/order-list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes_name.dart';

class SiteManagerHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('MRF List'),
        backgroundColor: Colors.orange,
        actions: [
          ReloadMrfs(),
          LogoutButton(),
        ],
      ),
      body: BlocListener<MrfCrudBloc, MrfCrudState>(
        listenWhen: (pre, cur) => pre != cur,
        listener: (_, state) {
          if (state is MrfCrudFailure) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text(state.error),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          if (state is MrfDeleteSuccess) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('MRF deleted successfully'),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.green,
              ),
            );
            return;
          }
        },
        child: MRFListView(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).pushNamed(RoutesName.createMrf);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
