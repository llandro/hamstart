import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hamstart/models/product.dart';
import 'package:hamstart/providers/categories.dart';
import 'package:hamstart/providers/products.dart';
import 'package:hamstart/screens/edit_category_screen.dart';
import 'package:hamstart/screens/edit_item_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final categories = Categories();
  final products = Products();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Categories>(create: (_) => categories),
        ChangeNotifierProvider<Products>(create: (_) => products),
      ],
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
//        routes: {
//          EditCategoryScreen.routeName: (ctx) => EditCategoryScreen(),
//          EditItemScreen.routeName: (ctx) => EditItemScreen(),
//        },
        onGenerateRoute: (settings) {
          if (settings.name == EditItemScreen.routeName) {
            final Map<String, dynamic> args = settings.arguments;
            if (args['product'] != null) {
              String categoryId = args['categoryId'];
              Product product = args['product'];
              return MaterialPageRoute(
                  builder: (ctx) => EditItemScreen(
                        categoryId: categoryId,
                        product: product,
                      ));
            } else {
              String categoryId = args['categoryId'];
              return MaterialPageRoute(
                  builder: (ctx) => EditItemScreen(
                        categoryId: categoryId,
                        product: null,
                      ));
            }
          } else if (settings.name == EditCategoryScreen.routeName) {
            //TODO: pass arguments to named route EditCategoryScreen
            return MaterialPageRoute(builder: (_) => EditCategoryScreen());
          } else
            return MaterialPageRoute(builder: (_) => CategoriesScreen());
        },
      ),
    );
  }
}
