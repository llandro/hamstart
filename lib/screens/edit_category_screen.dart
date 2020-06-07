import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamstart/widgets/input/image_input.dart';
import 'package:hamstart/providers/categories.dart';
import 'package:provider/provider.dart';

import 'package:hamstart/services/image_loader.dart';

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
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File _pickedImage;
  bool _isLoading = false;

  void _selectImage(File myPickedImage) {
    _pickedImage = myPickedImage;
  }

  void saveCategory() async {
    setState(() {
      _isLoading = true;
    });
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
      _titleController.text = widget.title;
      _descriptionController.text = widget.description;
    }
    super.initState();
  }

  Future<void> loadImage(loadingImageURL) async {
    File file = await ImageLoader.loadImage(loadingImageURL);
    _pickedImage = file;
  }

  Future<void> initImage() async {
    await loadImage(widget.imageURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                      height: 10,
                    ),
                    FutureBuilder(
                      future: loadImage(widget.imageURL),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !_isLoading) {
                          return CircularProgressIndicator();
                        }
                        return ImageInput(
                          onSelectImage: _selectImage,
                          previousImage: _pickedImage,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : RaisedButton.icon(
                    onPressed: saveCategory,
                    icon: Icon(Icons.add),
                    label: Text('Save category'),
                    elevation: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: Theme.of(context).accentColor,
                  )
          ],
        ),
      ),
    );
  }
}
