import 'package:crsewms/home/mrfs/crud/bloc/mrf_crud_bloc.dart';
import 'package:crsewms/repository/model/mrfs/mrf_list.dart';
import 'package:crsewms/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/mrf_list_bloc.dart';

class MRFListView extends StatelessWidget {
  final bool isApprovedMrf;

  const MRFListView({Key key, this.isApprovedMrf}) : super(key: key);

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
        if (state is EmptyMrfListState) {
          return Center(child: Text('No Mrf found.'));
        }
        if (state is MrfLoadState) {
          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.mrfList.length,
            separatorBuilder: (_, index) => Divider(),
            itemBuilder: (_, index) {
              return ListTile(
                title: _getMrfTile(index, state.mrfList[index]),
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
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                color: mrfData.reqStatus == 0 ? Colors.orange : Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  mrfData.reqStatus == 0 ? 'Pending' : 'Approved',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          _getTextView('Project', mrfData.project),
          _getTextView('Description', mrfData.desc),
          _getTextView('Req By', mrfData.createBy),
          _getTextView('Req Data', mrfData.createdAt),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AddOrViewStock(mrfData: mrfData),
              mrfData.reqStatus == 0 ? EditMrf(mrfData: mrfData) : SizedBox(),
              mrfData.reqStatus == 0
                  ? DeleteMrf(
                      mrfData: mrfData,
                      isApprovedMrf: isApprovedMrf,
                    )
                  : SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  Widget _getTextView(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        RichText(
          text: TextSpan(
            text: '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                  text: value, style: TextStyle(fontWeight: FontWeight.normal)),
            ],
          ),
        ),
      ],
    );
  }
}

class ReloadMrfs extends StatelessWidget {
  final bool isApprovedMrf;

  const ReloadMrfs({Key key, this.isApprovedMrf}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.refresh, color: Colors.white),
      onPressed: () {
        context.bloc<MrfListBloc>()
          ..add(FetchMRFs(isApprovedMrf: isApprovedMrf));
      },
    );
  }
}

class AddOrViewStock extends StatelessWidget {
  AddOrViewStock({Key key, @required this.mrfData}) : super(key: key);

  final MrfData mrfData;

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      icon: Icon(Icons.remove_red_eye, color: Colors.blueAccent),
      label: Text(
        mrfData.reqStatus == 0 ? 'Add Stock' : 'View stock',
        style: TextStyle(color: Colors.blueAccent),
      ),
      onPressed: () {
        Navigator.of(context)
            .pushNamed(RoutesName.stockDetail, arguments: mrfData.reqId);
      },
    );
  }
}

class EditMrf extends StatelessWidget {
  EditMrf({Key key, @required this.mrfData}) : super(key: key);

  final MrfData mrfData;

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      icon: Icon(Icons.edit, color: Colors.orange),
      label: Text(
        'Edit',
        style: TextStyle(color: Colors.orange),
      ),
      onPressed: () {
        Navigator.of(context)
            .pushNamed(RoutesName.editMrf, arguments: mrfData.reqId);
      },
    );
  }
}

class DeleteMrf extends StatelessWidget {
  DeleteMrf({Key key, @required this.mrfData, this.isApprovedMrf})
      : super(key: key);

  final MrfData mrfData;
  final bool isApprovedMrf;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MrfCrudBloc, MrfCrudState>(
      listener: (_, state) {
        if (state is MrfDeleteSuccess) {
          context.bloc<MrfListBloc>()
            ..add(FetchMRFs(isApprovedMrf: isApprovedMrf));
        }
      },
      child: FlatButton.icon(
        icon: Icon(Icons.delete, color: Colors.red),
        label: Text(
          'Delete',
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {
          context.bloc<MrfCrudBloc>()
            ..add(DeleteMrfEvent(mrfId: mrfData.reqId));
        },
      ),
    );
  }
}
