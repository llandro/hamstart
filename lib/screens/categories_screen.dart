import 'package:flutter/material.dart';
import 'package:hamstart/app_drawer.dart';
import 'package:hamstart/providers/categories.dart';
import 'package:hamstart/screens/add_category_screen.dart';
import 'package:hamstart/widgets/categories_grid.dart';

import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Categories>(context).fetchAndSetCategories().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Choose a category'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CategoriesGrid(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddCategoryScreen.routeName);
        },
      ),
    );
  }
}
