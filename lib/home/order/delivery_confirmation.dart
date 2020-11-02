import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/order_bloc.dart';

class DeliveryConfirmation extends StatefulWidget {
  final Object arguments;

  const DeliveryConfirmation({Key key, @required this.arguments})
      : super(key: key);

  @override
  _DeliveryConfirmationState createState() => _DeliveryConfirmationState();
}

class _DeliveryConfirmationState extends State<DeliveryConfirmation> {
  final picker = ImagePicker();
  File _image;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xFFffa354).withOpacity(0.8),
        title: Text('Stock Update', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        height: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _getImageView(),
            SizedBox(
              height: 24,
              child: Divider(),
            ),
            BlocConsumer<OrderBloc, OrderState>(
              listener: (_, state) {
                if (state is OrderUpdatedState) {
                  _showMessage(
                    'Status updated successfully.',
                    backgroundColor: Color(0xFFffa354),
                  );
                }
                if (state is OrderFailure) {
                  _showMessage(state.error, backgroundColor: Colors.red);
                }
              },
              builder: (_, state) {
                return _getUpdateButton(state);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getImageView() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Color(0xFFffa354)),
        image: _image != null
            ? DecorationImage(
                fit: BoxFit.fitHeight,
                image: FileImage(_image),
              )
            : null,
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Color(0xFFffa354)),
          color: Colors.black12.withOpacity(0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select Image',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                  color: Colors.white),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () => setImageByImageSource(
                    ImageSource.camera,
                  ),
                ),
                VerticalDivider(
                  color: Colors.red,
                  thickness: 5.0,
                ),
                IconButton(
                  icon: Icon(
                    Icons.photo,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () => setImageByImageSource(
                    ImageSource.gallery,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _getUpdateButton(OrderState state) {
    if (state is OrderLoading) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFff8b54)),
        backgroundColor: Colors.white,
      );
    }
    if (state is OrderUpdatedState) {
      return Container();
    }
    return RaisedButton.icon(
      textColor: Colors.white,
      color: Color(0xFFffa354),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _image == null ? null :  () {
        context.bloc<OrderBloc>()
          ..add(
            UpdateOrderStatus(arguments: widget.arguments, file: _image),
          );
      },
      icon: Icon(Icons.file_upload, size: 18),
      label: Text('Update Status'),
    );
  }

  Future<void> setImageByImageSource(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response == null || response.isEmpty) {
      return;
    }
    if (response.file == null) {
      return;
    }

    if (response.type == RetrieveType.video) {
      return;
    }

    setState(() {
      _image = File(response.file.path);
    });
  }

  _showMessage(String message, {Color backgroundColor = Colors.green}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
