import 'package:crsewms/home/mrfs/crud/crud.dart';
import 'package:crsewms/repository/model/mrfs/boq_list.dart';
import 'package:crsewms/repository/model/mrfs/location_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/components.dart';

class EditMrf extends StatefulWidget {
  EditMrf({Key key, @required this.argument}) : super(key: key);
  final Object argument;

  @override
  _EditMrfState createState() => _EditMrfState();
}

class _EditMrfState extends State<EditMrf> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Location pickupLocation;
  Location dropOffLocation;
  String descriptionController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Material request'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            _getLabel('Stock / W.H. Location'),
            _getCustomDropDown(
              pickupLocation == null ? 'Select here' : pickupLocation.name,
              onTap: () {
                _locationListViewPage(context, true);
              },
            ),
            _getLabel('Site delivery location'),
            _getCustomDropDown(
              dropOffLocation == null ? 'Select here' : dropOffLocation.name,
              onTap: () {
                _locationListViewPage(context, false);
              },
            ),
            _getLabel('Description'),
            TextField(
              onChanged: (value) {
                setState(() {
                  descriptionController = value;
                });
              },
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                filled: true,
                hintStyle: new TextStyle(color: Colors.grey[800]),
                hintText: "Type in your text",
                fillColor: Colors.white70,
              ),
            ),
            SizedBox(height: 16.0),
            UpdateButton(
              pageContext: context,
              dropOffLocation: dropOffLocation,
              argument: widget.argument,
              pickupLocation: pickupLocation,
              description: descriptionController,
              scaffoldKey: _scaffoldKey,
            ),
          ],
        ),
      ),
    );
  }

  Future _locationListViewPage(
      BuildContext context, bool isPickupLocation) async {
    context.bloc<MrfCrudBloc>()..add(FetchLocation());

    Location location = await Navigator.of(context).push(
      MaterialPageRoute<Location>(
        builder: (BuildContext context) => LocationListView(),
        fullscreenDialog: true,
      ),
    );
    if (location != null) {
      setState(() {
        if (isPickupLocation) {
          pickupLocation = location;
        } else {
          dropOffLocation = location;
        }
      });
    }
  }

  Widget _getCustomDropDown(String label, {@required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.black87,
            )
          ],
        ),
      ),
    );
  }

  Widget _getLabel(String label) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8.0),
        ],
      );
}

class UpdateButton extends StatelessWidget {
  UpdateButton({
    Key key,
    @required this.pageContext,
    @required this.argument,
    @required this.pickupLocation,
    @required this.dropOffLocation,
    @required this.description,
    @required this.scaffoldKey,
  }) : super(key: key);
  final BuildContext pageContext;
  final Object argument;
  final Location pickupLocation;
  final Location dropOffLocation;
  final String description;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MrfCrudBloc, MrfCrudState>(
      listener: (_, state) {
        if (state is MrfCrudFailure) {
          _showToast(state.error, Colors.red);
          return;
        }
        if (state is MRFSavedState) {
          _showToast('MRF update successfully', Colors.green);
          return;
        }
      },
      builder: (_, state) {
        if (state is MrfCrudLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Center(
          child: RaisedButton.icon(
            color: Colors.orange,
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              if (argument == null ||
                  pickupLocation == null ||
                  dropOffLocation == null) {
                _showToast('Missing form details', Colors.red);
                return;
              }

              context.bloc<MrfCrudBloc>()
                ..add(UpdateMrfEvent(
                  reqId: argument.toString(),
                  pickupLocation: pickupLocation,
                  dropOffLocation: dropOffLocation,
                  description: description,
                ));
              return;
            },
            label: Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  _showToast(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      backgroundColor: color,
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
