import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamstart/widgets/input/image_input.dart';
import 'package:hamstart/providers/categories.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class EditCategoryScreen extends StatefulWidget {
  static const routeName = '/categories/add_category';

  final String categoryId;
  final String title;
  final String description;
  final String imageURL;
  EditCategoryScreen(
      {this.categoryId, this.title, this.description, this.imageURL});

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  TextEditingController _titleController;
  TextEditingController _descriptionController = TextEditingController();
  File _pickedImage;

  void _selectImage(File myPickedImage) {
    _pickedImage = myPickedImage;
  }

  void saveCategory() async {
    if (widget.categoryId == null) {
      await Provider.of<Categories>(context, listen: false).addCategory(
        title: _titleController.text,
        description: _descriptionController.text,
        image: _pickedImage,
      );
    } else {
      await Provider.of<Categories>(context, listen: false).updateCategory(
        categoryId: widget.categoryId,
        title: _titleController.text,
        description: _descriptionController.text,
        image: _pickedImage,
      );
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    if (widget.categoryId != null) {
      _titleController = TextEditingController(text: widget.title);
      _descriptionController.text = widget.description;
      loadImage();
    }
    super.initState();
  }

  Future<void> loadImage() async {
    final http.Response responseData = await http.get(widget.imageURL);
    Uint8List uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();

    imageCache.clear();
    File file = await File('${tempDir.path}/img}').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    setState(() {
      _pickedImage = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Description'),
                    controller: _descriptionController,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ImageInput(
                    onSelectImage: _selectImage,
                    previousImage: _pickedImage,
                  ),
                ],
              ),
            ),
          ),
          RaisedButton.icon(
            onPressed: saveCategory,
            icon: Icon(Icons.add),
            label: Text('Save category'),
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
          )
        ],
      ),
    );
  }
}
