import 'package:flutter/material.dart';
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
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      //darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      routes: {
        "/": (BuildContext context) => const LogIn(),
        "/home": (BuildContext context) => const NavBottom(),
        "/signup": (BuildContext context) => const SignUp()
      },
    );
  }
}
