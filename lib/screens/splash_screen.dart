import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: 200,
                child: Image.asset(
                  'assets/images/s1200.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  value: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
