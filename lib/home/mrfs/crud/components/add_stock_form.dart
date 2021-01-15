import 'package:crsewms/custom_service/custom_service.dart';
import 'package:crsewms/home/mrfs/crud/bloc/mrf_crud_bloc.dart';
import 'package:crsewms/repository/model/mrfs/stocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components.dart';

class StockFormPage extends StatefulWidget {
  StockFormPage({Key key, @required this.id}) : super(key: key);
  final String id;

  @override
  _StockFormPageState createState() => _StockFormPageState();
}

class _StockFormPageState extends State<StockFormPage> {
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  StockInfo stockInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Stock'),
        backgroundColor: Colors.orange,
        actions: [
          BlocListener<MrfCrudBloc, MrfCrudState>(
            listener: (_, state) {
              if (state is StockSavedSuccessState) {
                Navigator.of(context).pop();
              }
            },
            child: IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () {
                if (stockInfo == null) {
                  CustomService.showMessage(
                    _scaffoldKey,
                    'Select stock from available list',
                    backgroundColor: Colors.red,
                  );
                  return;
                }

                if (_quantityController.text?.isEmpty ?? true) {
                  CustomService.showMessage(
                    _scaffoldKey,
                    'Select quantity for selected stock.',
                    backgroundColor: Colors.red,
                  );
                  return;
                }

                if (_remarksController.text?.isEmpty ?? true) {
                  CustomService.showMessage(
                    _scaffoldKey,
                    'Add remarks for selected stock.',
                    backgroundColor: Colors.red,
                  );
                  return;
                }

                context.bloc<MrfCrudBloc>()
                  ..add(AddStockToMrf(
                    id: widget.id,
                    stockId: stockInfo.isid.toString(),
                    remarks: _remarksController.text,
                    quantity: _quantityController.text,
                  ));
              },
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Available stock',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            GestureDetector(
              onTap: () => _boqListPage(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(stockInfo == null ? 'Select here' : stockInfo.iname),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Theme(
              data: new ThemeData(
                primaryColor: Colors.orange,
                primaryColorDark: Colors.orange,
              ),
              child: TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  labelText: 'Quantity',
                  labelStyle: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Theme(
              data: new ThemeData(
                primaryColor: Colors.orange,
                primaryColorDark: Colors.orange,
              ),
              child: TextField(
                controller: _remarksController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  labelText: 'Comments',
                  labelStyle: TextStyle(color: Colors.black87),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _boqListPage(BuildContext context) async {
    StockInfo stockInfo = await Navigator.of(context).push(
      MaterialPageRoute<StockInfo>(
        builder: (BuildContext _) => StocksItem(),
        fullscreenDialog: true,
      ),
    );

    if (stockInfo != null) {
      setState(() {
        this.stockInfo = stockInfo;
      });
    }
  }
}
