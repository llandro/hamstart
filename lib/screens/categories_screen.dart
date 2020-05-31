import 'package:flutter/material.dart';
import 'file:///D:/development/dart_udemy_3/hamstart/lib/app_drawer.dart';
import 'package:hamstart/screens/add_category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Choose a category'),
      ),
      body: Container(
        child: Center(
          child: Text('No categories added yet'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddCategoryScreen.routeName);
        },
      ),
    );
  }
}
