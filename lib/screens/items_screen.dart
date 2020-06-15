import 'package:flutter/material.dart';
import 'package:hamstart/screens/edit_item_screen.dart';
import 'package:provider/provider.dart';
import 'package:hamstart/providers/products.dart';

class ItemsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;
  ItemsScreen(this.categoryId, this.categoryTitle);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
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
    final items =
        Provider.of<Products>(context).categoryItems(widget.categoryId);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : items.length == 0
              ? Center(
                  child: Text('No items in this category yet. Add one'),
                )
              : null,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final argument = {'categoryId': widget.categoryId};
          Navigator.of(context)
              .pushNamed(EditItemScreen.routeName, arguments: argument);
        },
      ),
    );
  }
}
