import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hamstart/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<Product> get items => [..._items];
  List<Product> categoryItems(String categoryId) =>
      [..._items].where((element) => element.categoryId == categoryId).toList();

  Future<void> addProduct({
    String categoryId,
    String title,
    String description,
    double quantity,
    File image,
    File painting,
    List<File> additionalImages,
    Map<String, dynamic> additionalFields,
  }) async {
    final currentUser = await FirebaseAuth.instance.currentUser();

    final addedRecord = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('categories')
        .document(categoryId)
        .collection('products')
        .add({
      'title': title,
      'description': description,
      'quantity': quantity,
      'additionalFields': additionalFields,
    });
    final productId = addedRecord.documentID;

    String imageURL = '';
    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('${currentUser.uid}')
          .child('categories')
          .child('$categoryId')
          .child('$productId')
          .child('main_image');
      await ref.putFile(image).onComplete;
      imageURL = (await ref.getDownloadURL()).toString();
    }

    String paintingURL = '';
    if (painting != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('${currentUser.uid}')
          .child('categories')
          .child('$categoryId')
          .child('$productId')
          .child('painting_image');
      await ref.putFile(painting).onComplete;
      paintingURL = (await ref.getDownloadURL()).toString();
    }

    List<String> additionalImagesURL = [];
    if (additionalImages != null) {
      for (int i = 0; i < additionalImages.length; i++) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('${currentUser.uid}')
            .child('categories')
            .child('$categoryId')
            .child('$productId')
            .child('images')
            .child('image$i');
        await ref.putFile(additionalImages[i]).onComplete;
        String newImgUrl = (await ref.getDownloadURL()).toString();
        additionalImagesURL.add(newImgUrl);
      }
    }
    await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('categories')
        .document(categoryId)
        .collection('products')
        .document(productId)
        .updateData({
      'imageURL': imageURL,
      'paintingURL': paintingURL,
      'additionalPictures': additionalImagesURL,
    });
    _items.add(Product(
      categoryId: categoryId,
      productId: productId,
      title: title,
      description: description,
      quantity: quantity,
      imageURL: imageURL,
      paintingURL: paintingURL,
      additionalFields: additionalFields,
      additionalPictures: additionalImagesURL,
    ));
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final categories = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .collection('categories')
        .getDocuments();

    _items.clear();
    for (var category in categories.documents) {
      final categoryItems = await Firestore.instance
          .collection('users')
          .document(currentUser.uid)
          .collection('categories')
          .document(category.documentID)
          .collection('products')
          .getDocuments();
      _items.addAll(
        categoryItems.documents
            .map(
              (e) => Product(
                categoryId: category.documentID,
                productId: e.documentID,
                title: e['title'],
                description: e['description'],
                quantity: e['quantity'],
                imageURL: e['imageURL'],
                paintingURL: e['paintingURL'],
                additionalFields: e['additionalFields'],
                additionalPictures: e['additionalPictures'],
              ),
            )
            .toList(),
      );
    }
    notifyListeners();
  }
}
