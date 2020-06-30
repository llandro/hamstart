import 'package:flutter/material.dart';
import 'package:hamstart/providers/products.dart';
import 'package:hamstart/widgets/items/item_item.dart';
import 'package:provider/provider.dart';

class ItemsGrid extends StatelessWidget {
  final String categoryId;
  ItemsGrid(this.categoryId);
  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Products>(context).categoryItems(categoryId);
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, idx) => ItemItem(
        title: items[idx].title,
        productId: items[idx].productId,
        imageURL: items[idx].imageURL,
        paintingURL: items[idx].paintingURL,
        qty: items[idx].quantity,
      ),
    );
  }
}
