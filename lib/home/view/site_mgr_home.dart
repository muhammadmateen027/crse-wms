import 'package:crsewms/home/mrfs/crud/crud.dart';
import 'package:crsewms/home/mrfs/mrfs.dart';
import 'package:crsewms/home/order/order-list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SiteManagerHome extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('MRF List'),
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
                ));
            return;
          }
        },
        child: MRFListView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favourite'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed:scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }
}