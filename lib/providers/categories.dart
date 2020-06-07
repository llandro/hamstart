import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hamstart/models/category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Categories with ChangeNotifier {
  List<Category> _items = [];

  List<Category> get items {
    return [..._items];
  }

  Future<void> addCategory(
      {String title, String description, File image}) async {
    final currentUser = await FirebaseAuth.instance.currentUser();

    final addedRecord = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('categories')
        .add({
      'title': title,
      'description': description,
    });

    final categoryId = addedRecord.documentID;

    final ref = FirebaseStorage.instance
        .ref()
        .child('${currentUser.uid}')
        .child('categories')
        .child('$categoryId.jpg');
    await ref.putFile(image).onComplete;
    final imageUrl = (await ref.getDownloadURL()).toString();

    await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('categories')
        .document(categoryId)
        .setData({'imageURL': imageUrl}, merge: true);
    _items.add(Category(
      categoryId: categoryId,
      title: title,
      description: description,
      imageURL: imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateCategory(
      {@required String categoryId,
      String title,
      String description,
      File image}) async {
    final currentUser = await FirebaseAuth.instance.currentUser();

    await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('categories')
        .document(categoryId)
        .setData({'title': title, 'description': description});

    final ref = FirebaseStorage.instance
        .ref()
        .child('${currentUser.uid}')
        .child('categories')
        .child('$categoryId.jpg');
    await ref.putFile(image).onComplete;

    final imageUrl = (await ref.getDownloadURL()).toString();

    await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('categories')
        .document(categoryId)
        .setData({'imageURL': imageUrl}, merge: true);

    final indexOfEl =
        _items.indexWhere((element) => element.categoryId == categoryId);
    _items[indexOfEl].description = description;
    _items[indexOfEl].title = title;
    _items[indexOfEl].imageURL = imageUrl;

    notifyListeners();
  }

  Future<void> removeCategory(String categoryId) async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final ref = FirebaseStorage.instance
        .ref()
        .child('${currentUser.uid}')
        .child('categories')
        .child('$categoryId.jpg');
    await ref.delete();

    await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('categories')
        .document(categoryId)
        .delete();

    await fetchAndSetCategories();
  }

  Future<void> fetchAndSetCategories() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final categories = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('categories')
        .getDocuments();
    _items = categories.documents.map(
      (e) {
        return Category(
          categoryId: e.documentID,
          title: e['title'],
          description: e['description'],
          imageURL: e['imageURL'],
        );
      },
    ).toList();
    notifyListeners();
  }
}
