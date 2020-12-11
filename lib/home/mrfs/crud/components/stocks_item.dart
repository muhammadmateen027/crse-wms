import 'package:crsewms/home/mrfs/crud/crud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StocksItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Items'),backgroundColor: Colors.orange,),
      body: BlocBuilder<MrfCrudBloc, MrfCrudState>(
        buildWhen: (prev, curr) => prev != curr,
        builder: (_, state) {
          if (state is MrfCrudFailure) {
            return Center(
              child: Text(
                state.error,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is StockListLoaded) {
            return ListView.separated(
              itemCount: state.stockList.length,
              separatorBuilder: (_, index) => Divider(),
              itemBuilder: (_, index) {
                return ListTile(
                  onTap: () => Navigator.of(context).pop(state.stockList[index]),
                  title: Text(state.stockList[index].iname),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
