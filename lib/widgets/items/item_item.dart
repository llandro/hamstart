import 'package:flutter/material.dart';

class ItemItem extends StatelessWidget {
  final String productId;
  final String title;
  final String imageURL;
  final String paintingURL;

  ItemItem({
    this.productId,
    this.title,
    this.imageURL,
    this.paintingURL,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          if (imageURL != null && paintingURL != null)
            Row(
              children: <Widget>[
                Container(
                  width: 150,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/s1200.jpg'),
                    image: NetworkImage(imageURL),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 150,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/s1200.jpg'),
                    image: NetworkImage(paintingURL),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          if (imageURL != null && paintingURL == null)
            Container(
              width: 300,
              child: FadeInImage(
                placeholder: AssetImage('assets/images/s1200.jpg'),
                image: NetworkImage(imageURL),
                fit: BoxFit.cover,
              ),
            ),
          if (imageURL == null && paintingURL != null)
            Container(
              width: 300,
              child: FadeInImage(
                placeholder: AssetImage('assets/images/s1200.jpg'),
                image: NetworkImage(paintingURL),
                fit: BoxFit.cover,
              ),
            ),
          if (imageURL == null && paintingURL == null)
            Container(
              width: 300,
              child: Image.asset(
                'assets/images/s1200.jpg',
                fit: BoxFit.cover,
              ),
            ),
          Text(title),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      onTap: () {
        print(productId);
      },
    );
  }
}
