import 'package:crsewms/repository/model/mrfs/mrf_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/mrf_list_bloc.dart';

class MRFListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MrfListBloc, MrfListState>(
      buildWhen: (prev, curr) => prev != curr,
      builder: (_, state) {
        if (state is MrfListFailure) {
          return Container(
            child: Text(state.error, style: TextStyle(color: Colors.red)),
          );
        }
        if (state is MrfLoadState) {
          return ListView.separated(
            itemCount: 20,
            separatorBuilder: (_, index) => Divider(),
            itemBuilder: (_, index) {
              return ListTile(
                title: _getMrfTile(index, state.mrfList[0]),
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _getMrfTile(int index, MrfData mrfData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(1.0)),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(index.toString()),
              Container(
                color: mrfData.reqStatus == 0 ? Colors.orange : Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  mrfData.reqStatus == 0 ? 'Pending' : 'Approved',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            mrfData.project,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class ReloadMrfs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.refresh, color: Colors.black),
      onPressed: () {
        context.bloc<MrfListBloc>()..add(FetchMRFs());
      },
    );
  }
}
