import 'package:crsewms/home/mrfs/bloc/mrf_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MrfList extends StatefulWidget {
  const MrfList({Key key, @required this.label}) : super(key: key);
  final String label;

  @override
  _MrfListState createState() => _MrfListState();
}

class _MrfListState extends State<MrfList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFffa354).withOpacity(0.8),
        title: Text(widget.label, style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.white.withOpacity(0.4),
        width: double.maxFinite,
        height: double.maxFinite,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: BlocConsumer<MrfBloc, MrfState>(
          listener: (_, state) {},
          builder: (_, state) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                'Order is not available.',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
