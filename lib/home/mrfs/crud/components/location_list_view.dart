import 'package:crsewms/home/mrfs/crud/crud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
        backgroundColor: Colors.orange,
      ),
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
          if (state is LocationLoaded) {
            return ListView.separated(
              itemCount: state.locations.length,
              separatorBuilder: (_, index) => Divider(),
              itemBuilder: (_, index) {
                return ListTile(
                  onTap: () =>
                      Navigator.of(context).pop(state.locations[index]),
                  title: Text(state.locations[index].name),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
