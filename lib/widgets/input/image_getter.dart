import 'dart:io';
import 'package:flutter/material.dart';

class ImageGetter extends StatelessWidget {
  final Function loadImage;
  final File image;
  final onTap;
  final String title;

  ImageGetter({this.title, this.loadImage, this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          child: Container(
            height: 200,
            width: 200,
            child: FutureBuilder(
              future: loadImage(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return image != null
                    ? Image.file(
                        image,
                        fit: BoxFit.cover,
                      )
                    : Image.asset('assets/images/s1200.jpg');
              },
            ),
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}
