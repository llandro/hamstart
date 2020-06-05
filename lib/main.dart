import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hamstart/providers/categories.dart';
import 'package:hamstart/screens/add_category_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final categories = Categories();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: categories,
      child: MaterialApp(
        title: 'HamstArt',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SplashScreen();
            if (snapshot.hasData) return CategoriesScreen();
            return AuthScreen();
          },
        ),
        routes: {
          EditCategoryScreen.routeName: (ctx) => EditCategoryScreen(),
        },
      ),
    );
  }
}
