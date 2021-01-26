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
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.mrfList.length,
            padding: EdgeInsets.zero,
            itemBuilder: (_, index) {
              return _getMrfTile(index, state.mrfList[index]);
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _getMrfTile(int index, MrfData mrfData) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  color: mrfData.reqStatus == 0 ? Colors.orange : Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
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
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getTextView('Project', mrfData.project),
                _getTextView('Description', mrfData.desc),
                _getTextView('Req By', mrfData.createBy),
                _getTextView('Req Data', mrfData.createdAt),
                _getTextView('BOQ No.', mrfData.boqNumber),
                _getTextView('MRF No.', mrfData.document),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddOrViewStock(mrfData: mrfData),
              mrfData.reqStatus == 0
                  ? EditMrf(mrfData: mrfData, isApprovedMrf: isApprovedMrf)
                  : SizedBox(),
              mrfData.reqStatus == 0
                  ? DeleteMrf(mrfData: mrfData, isApprovedMrf: isApprovedMrf)
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
                text: value,
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
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
    return Flexible(
      flex: 3,
      child: FlatButton.icon(
        icon: Icon(Icons.remove_red_eye, color: Colors.blueAccent),
        label: Text(
          mrfData.reqStatus == 0 ? 'Add Stock' : 'View stock',
          style: TextStyle(color: Colors.blueAccent),
        ),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(RoutesName.stockDetail, arguments: mrfData.reqId);
        },
      ),
    );
  }
}

class EditMrf extends StatelessWidget {
  EditMrf({Key key, @required this.mrfData, @required this.isApprovedMrf})
      : super(key: key);

  final MrfData mrfData;
  final bool isApprovedMrf;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: FlatButton.icon(
        icon: Icon(Icons.edit, color: Colors.orange),
        label: Text('Edit', style: TextStyle(color: Colors.orange)),
        onPressed: () async {
          final result = await Navigator.of(context)
              .pushNamed(RoutesName.editMrf, arguments: mrfData);

          context.bloc<MrfListBloc>()
            ..add(FetchMRFs(isApprovedMrf: isApprovedMrf));
        },
      ),
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
    return Flexible(
      flex: 3,
      child: BlocListener<MrfCrudBloc, MrfCrudState>(
        listener: (_, state) {
          if (state is MrfDeleteSuccess) {
            context.bloc<MrfListBloc>()
              ..add(FetchMRFs(isApprovedMrf: isApprovedMrf));
          }
        },
        child: FlatButton.icon(
          icon: Icon(Icons.delete, color: Colors.red),
          label: Text('Delete', style: TextStyle(color: Colors.red)),
          onPressed: () => _showAlertDialog(context),
        ),
      ),
    );
  }

  _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Cancel'),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = FlatButton(
      child: Text('yes'),
      onPressed: () {
        context.bloc<MrfCrudBloc>()..add(DeleteMrfEvent(mrfId: mrfData.reqId));
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Delete'),
      content: Text('Press yes to delete item from list?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(context: context, builder: (_) => alert);
  }
}
