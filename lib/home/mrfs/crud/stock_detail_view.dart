import 'package:crsewms/home/mrfs/crud/crud.dart';
import 'package:crsewms/repository/model/mrfs/stock_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/components.dart';

class StockDetailView extends StatefulWidget {
  StockDetailView({Key key, @required this.argument}) : super(key: key);
  final Object argument;

  @override
  _StockDetailViewState createState() => _StockDetailViewState();
}

class _StockDetailViewState extends State<StockDetailView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    context.bloc<MrfCrudBloc>()
      ..add(GetStockDetailEvent(id: widget.argument.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditableFloating = false;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Stock detail'),
        backgroundColor: Colors.orange,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: isEditableFloating ? null : () => _boqListPage(context),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: BlocListener<MrfCrudBloc, MrfCrudState>(
        listener: (_, state) {
          if (state is StockDetailLoadedState) {
            if (state.stockDetail.reqStatus == 0) {
              setState(() {
                isEditableFloating = true;
              });
            }
          }
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                StockInfoWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _boqListPage(BuildContext context) async {
    context.bloc<MrfCrudBloc>()..add(FetchStockList());

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext _) =>
            StockFormPage(id: widget.argument.toString()),
        fullscreenDialog: true,
      ),
    );

    context.bloc<MrfCrudBloc>()
      ..add(GetStockDetailEvent(id: widget.argument.toString()));
  }
}

class StockInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MrfCrudBloc, MrfCrudState>(
      buildWhen: (prev, curr) {
        if (curr is StockDetailLoadedState) {
          return true;
        }
        if (curr is MrfCrudLoading) {
          return true;
        }
        return false;
      },
      builder: (_, state) {
        if (state is MrfCrudLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is StockDetailLoadedState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                _getStockDetail(state.stockDetail),
                Divider(),
                state.stockDetail.stock.length == 0
                    ? Center(
                        child: Text(
                          'No stock available.\nClick + to add stock',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : Container(
                        child: _stockListView(context, state.stockDetail)),
                SizedBox(height: 60),
              ],
            ),
          );
        }
        return Center();
      },
    );
  }

  Widget _stockListView(BuildContext context, StockDetail stockDetail) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: stockDetail.stock.length,
      separatorBuilder: (_, i) => Divider(),
      itemBuilder: (_, index) {
        return ListTile(
          title: Text(stockDetail.stock[index].iname),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailLabelView('Category', stockDetail.stock[index].category),
              _detailLabelView('Quantity', stockDetail.stock[index].qty),
              _detailLabelView(
                  'Approved Quantity', stockDetail.stock[index].appQty),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showAlertDialog(
                context,
                stockDetail.reqId.toString(),
                stockDetail.stock[index].rid.toString(),
              );
            },
          ),
        );
      },
    );
  }

  showAlertDialog(BuildContext context, String reqId, String rId) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Cancel'),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = FlatButton(
      child: Text('yes'),
      onPressed: () {
        context.bloc<MrfCrudBloc>()
          ..add(
            DeleteStockEvent(reqId: reqId, stockId: rId),
          );
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

  Widget _getStockDetail(StockDetail stockDetail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailLabelView('Project', stockDetail.project),
          SizedBox(height: 8),
          _detailLabelView('Document', stockDetail.document),
          SizedBox(height: 8),
          _detailLabelView('Description', stockDetail.desc),
          SizedBox(height: 8),
          _detailLabelView('Req By', stockDetail.createBy),
          SizedBox(height: 8),
          _detailLabelView('Stock Location',
              '${stockDetail.originName}, ${stockDetail.originAddress}'),
          SizedBox(height: 8),
          _detailLabelView('Destination Location',
              '${stockDetail.destinationName}, ${stockDetail.destinationAddress}'),
          SizedBox(height: 8),
          _detailLabelView('Req Date', stockDetail.createdAt),
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
}
