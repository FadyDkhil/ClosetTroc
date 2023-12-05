import 'package:flutter/material.dart';
import 'package:ratrappage_fady_dkhil/Bag/bag.dart';
import 'package:ratrappage_fady_dkhil/Shop/Show/global/products.dart';
import 'package:ratrappage_fady_dkhil/Shop/Show/user/my_products.dart';
import 'package:ratrappage_fady_dkhil/Shop/add_product.dart';
import 'package:ratrappage_fady_dkhil/navigations/nav_bottom.dart';
import 'package:ratrappage_fady_dkhil/user/login.dart';
import 'package:ratrappage_fady_dkhil/user/signup.dart';
import "color_schemes.g.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: themeDataTest),
      //darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      routes: {
        "/": (BuildContext context) => const LogIn(),
        "/home": (BuildContext context) => const NavBottom(),
        "/signup": (BuildContext context) => const SignUp(),
        "/products/add": (BuildContext context) => const AddProduct(),
        "/products": (BuildContext context) => const Products(),
        "/products/user": (BuildContext context) => const MyProducts(),
        "/bag": (BuildContext context) => const Bag()
      },
    );
  }
}
