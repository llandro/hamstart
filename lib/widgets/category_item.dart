import 'package:flutter/material.dart';
import 'package:hamstart/screens/edit_category_screen.dart';
import 'package:hamstart/providers/categories.dart';
import 'package:provider/provider.dart';

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
  void _editCategory() {
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
  }

  void _removeCategory() {
    Provider.of<Categories>(context, listen: false)
        .removeCategory(widget.categoryId);
  }

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
      onTap: () {},
      onLongPress: () async {
        final value = await showMenu(
            context: context,
            position: new RelativeRect.fromLTRB(65.0, 40.0, 0.0, 0.0),
            items: [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.edit),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Delete'),
                  ],
                ),
              ),
            ]);
        if (value == 'edit') {
          _editCategory();
        } else if (value == 'delete') {
          _removeCategory();
        }
      },
    );
  }
}
