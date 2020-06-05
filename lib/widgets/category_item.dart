import 'package:flutter/material.dart';
import 'package:hamstart/screens/add_category_screen.dart';

class CategoryItem extends StatefulWidget {
  final String imageURL;
  final String title;
  final String categoryId;
  final String description;

  CategoryItem({
    @required this.categoryId,
    this.imageURL,
    this.title,
    this.description,
  });

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(children: [
        Container(
          width: 300,
          child: FadeInImage(
            placeholder: AssetImage('assets/images/s1200.jpg'),
            image: NetworkImage(widget.imageURL),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5)),
          child: Text(
            widget.title,
          ),
        )
      ]),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => EditCategoryScreen(
              categoryId: widget.categoryId,
              title: widget.title,
              description: widget.description,
              imageURL: widget.imageURL,
            ),
          ),
        );
      },
    );
  }
}
