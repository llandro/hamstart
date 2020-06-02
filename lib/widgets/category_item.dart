import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String imageURL;
  final String title;
  CategoryItem({this.imageURL, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: FadeInImage(
        placeholder: AssetImage('assets/images/s1200.jpg'),
        image: NetworkImage(imageURL),
        fit: BoxFit.cover,
      ),
    );
  }
}
