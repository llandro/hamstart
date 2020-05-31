import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hamstart/widgets/input/image_input.dart';

class AddCategoryScreen extends StatefulWidget {
  static const routeName = '/categories/add_category';
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  File _pickedImage;

  void _selectImage(File myPickedImage) {
    _pickedImage = myPickedImage;
  }

  void saveCategory() async {
    final currentUser = await FirebaseAuth.instance.currentUser();

    final addedRecord = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('categories')
        .add({
      'title': _titleController.text,
      'description': _descriptionController.text
    });

    final categoryId = addedRecord.documentID;

    final ref = FirebaseStorage.instance
        .ref()
        .child('${currentUser.uid}')
        .child('categories')
        .child('$categoryId.jpg');
    await ref.putFile(_pickedImage).onComplete;
    final imageUrl = (await ref.getDownloadURL()).toString();

    await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('categories')
        .document(categoryId)
        .setData({'imageURL': imageUrl}, merge: true);

    Navigator.of(context).pop();
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
                  ImageInput(_selectImage),
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
