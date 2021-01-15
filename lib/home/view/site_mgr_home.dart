import 'dart:io';

import 'package:crsewms/home/mrfs/crud/crud.dart';
import 'package:crsewms/home/mrfs/mrf_list/bloc/mrf_list_bloc.dart';
import 'package:crsewms/home/mrfs/mrfs.dart';
import 'package:crsewms/home/order/order-list.dart';
import 'package:crsewms/repository/model/mrfs/mrf_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes_name.dart';

class SiteManagerHome extends StatefulWidget {
  @override
  _SiteManagerHomeState createState() => _SiteManagerHomeState();
}

class _SiteManagerHomeState extends State<SiteManagerHome>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<MrfData> mrfList = [];
  final ScrollController _scrollController = ScrollController();
  TabController controller;
  bool isApprovedMrf = false;

  @override
  void initState() {
    _scrollController.addListener(() {});
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _getSearchField(),
          BlocListener<MrfCrudBloc, MrfCrudState>(
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

              if (state is ScannedSuccessState) {
                Navigator.of(context)
                    .pushNamed(RoutesName.stockDetail, arguments: state.reqId);
              }
            },
            child: SliverList(
              delegate: SliverChildListDelegate(<Widget>[MRFListView()]),
            ),
          ),
        ],
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

  Widget _getSearchField() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: false,
      stretch: true,
      centerTitle: Platform.isIOS,
      expandedHeight: 160,
      title: Text('MRF List'),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        ReloadMrfs(),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 60,
              ),
              Container(
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
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.center_focus_weak),
                      onPressed: () {
                        context.bloc<MrfCrudBloc>()..add(ScanMrfEvent());
                      },
                    ),
                  ),
                  autovalidate: true,
                  onChanged: (query) {
                    context.bloc<MrfListBloc>()
                      ..add(SearchMRFEvent(query: query));
                  },
                ),
              ),
              TabBar(
                tabs: [Tab(text: 'Pending', ), Tab(text: 'Approved')],
                controller: controller,
                onTap: (index) {
                  if (index == 0) {
                    setState(() => isApprovedMrf = false);
                    context.bloc<MrfListBloc>()..add(FetchMRFs(isApprovedMrf: false));
                    return;
                  }
                  context.bloc<MrfListBloc>()..add(FetchMRFs(isApprovedMrf: true));
                  setState(() => isApprovedMrf = true);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
