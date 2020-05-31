import 'package:flutter/cupertino.dart';
import 'package:hamstart/models/category.dart';

class Categories with ChangeNotifier {
  List<Category> _items = [];

  List<Category> get items {
    return [..._items];
  }

  Future<void> fetchAndSetCategories() async {}
}
