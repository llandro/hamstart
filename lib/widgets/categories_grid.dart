import 'package:flutter/material.dart';
import 'package:hamstart/widgets/input/image_input.dart';
import 'package:provider/provider.dart';

import 'package:hamstart/providers/categories.dart';
import 'package:hamstart/widgets/category_item.dart';

class CategoriesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<Categories>(context).items;
    return GridView.builder(
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, idx) => CategoryItem(
        categoryId: categories[idx].categoryId,
        description: categories[idx].description,
        title: categories[idx].title,
        imageURL: categories[idx].imageURL,
      ),
    );
  }
}
