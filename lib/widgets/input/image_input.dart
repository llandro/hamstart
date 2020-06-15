import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hamstart/services/image_loader.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  final File previousImage;
  ImageInput({
    this.onSelectImage,
    this.previousImage,
  });

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;
  TextEditingController _URLController = TextEditingController();
  bool _isInit = true;

  @override
  void initState() {
    _storedImage = widget.previousImage;
    super.initState();
  }

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = imageFile;
    });
    if (imageFile == null) return;
    widget.onSelectImage(_storedImage);
  }

  Future<void> _loadPicture() async {
    if (_URLController.text.trim() != '') {
      try {
        final imageFile =
            await ImageLoader.loadImage(_URLController.text.trim());
        setState(() {
          _storedImage = imageFile;
        });
        widget.onSelectImage(_storedImage);
      } catch (e) {
        print('Invalid URL');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: _storedImage != null
                  ? Image.file(
                      _storedImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Text(
                      'No image',
                      textAlign: TextAlign.center,
                    ),
              alignment: Alignment.center,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: FlatButton.icon(
                onPressed: _takePicture,
                icon: Icon(Icons.camera),
                label: Text('Take picture'),
                textColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Picture URL'),
                controller: _URLController,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: _loadPicture,
            )
          ],
        )
      ],
    );
  }
}
