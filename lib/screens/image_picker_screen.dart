import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamstart/widgets/input/image_input.dart';

class ImagePickerScreen extends StatefulWidget {
  final File previousImage;
  final String title;
  final Function onSelectImage;
  ImagePickerScreen({this.previousImage, this.title, this.onSelectImage});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File _pickedImage;

  @override
  void initState() {
    _pickedImage = widget.previousImage;
    super.initState();
  }

  void onSelectImage(File newImage) {
    setState(() {
      _pickedImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageInput(
              previousImage: _pickedImage,
              onSelectImage: onSelectImage,
            ),
          ),
          RaisedButton.icon(
            onPressed: () {
              widget.onSelectImage(_pickedImage);
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.add),
            label: Text('Save image'),
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }
}
