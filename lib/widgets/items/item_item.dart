import 'package:flutter/material.dart';
import 'package:hamstart/screens/edit_item_screen.dart';
import 'package:provider/provider.dart';
import 'package:hamstart/providers/products.dart';

class ItemItem extends StatelessWidget {
  final String productId;
  final String title;
  final String imageURL;
  final String paintingURL;
  final double qty;

  ItemItem({
    this.productId,
    this.title,
    this.imageURL,
    this.paintingURL,
    this.qty,
  });

  void _editItem(BuildContext context) {
    final item = Provider.of<Products>(context, listen: false)
        .items
        .firstWhere((element) => element.productId == productId);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditItemScreen(
          categoryId: item.categoryId,
          product: item,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Column(
            children: <Widget>[
              if (imageURL != null &&
                  paintingURL != null &&
                  imageURL != '' &&
                  paintingURL != '')
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FadeInImage(
                        width: 150,
                        height: 70,
                        placeholder: AssetImage('assets/images/s1200.jpg'),
                        image: NetworkImage(imageURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: FadeInImage(
                        width: 150,
                        height: 70,
                        placeholder: AssetImage('assets/images/s1200.jpg'),
                        image: NetworkImage(paintingURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              if (imageURL != null &&
                  imageURL != '' &&
                  (paintingURL == null || paintingURL == ''))
                Container(
                  width: 300,
                  height: 70,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/s1200.jpg'),
                    image: NetworkImage(imageURL),
                    fit: BoxFit.cover,
                  ),
                ),
              if ((imageURL == null || imageURL == '') &&
                  (paintingURL != null && paintingURL != ''))
                Container(
                  width: 300,
                  height: 70,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/s1200.jpg'),
                    image: NetworkImage(paintingURL),
                    fit: BoxFit.cover,
                  ),
                ),
              if ((imageURL == null || imageURL == '') &&
                  (paintingURL == null || paintingURL == ''))
                Container(
                  width: 300,
                  height: 70,
                  child: Image.asset(
                    'assets/images/s1200.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
          onTap: () {
            _editItem(context);
          },
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.brightness_1,
                color: qty < 0.33
                    ? Colors.red
                    : qty < 0.66 ? Colors.yellow : Colors.green,
              ),
              onPressed: () {
                double newQty = 0;
                if (qty < 0.33)
                  newQty = 0.5;
                else if (qty < 0.66)
                  newQty = 1;
                else
                  newQty = 0;
                Provider.of<Products>(context, listen: false)
                    .updateQty(productId, newQty);
              },
            ),
            Flexible(child: Text(title)),
          ],
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
