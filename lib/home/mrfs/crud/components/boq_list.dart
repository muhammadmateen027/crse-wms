import 'package:crsewms/home/mrfs/crud/crud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoqListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BOQs'),),
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
          if (state is BoqLoaded) {
            return ListView.separated(
              itemCount: state.boqs.length,
              separatorBuilder: (_, index) => Divider(),
              itemBuilder: (_, index) {
                return ListTile(
                  onTap: () => Navigator.of(context).pop(state.boqs[index]),
                  title: Text(state.boqs[index].docNum),
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
