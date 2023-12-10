import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ratrappage_fady_dkhil/Bag/bag.dart';
import 'package:ratrappage_fady_dkhil/Shop/Show/global/products.dart';
import 'package:ratrappage_fady_dkhil/Shop/Show/user/my_products.dart';
import 'package:ratrappage_fady_dkhil/Shop/add_product.dart';
import 'package:ratrappage_fady_dkhil/navigations/nav_bottom.dart';
import 'package:ratrappage_fady_dkhil/user/Settings/Settings.dart';
import 'package:ratrappage_fady_dkhil/user/Settings/change_birth.dart';
import 'package:ratrappage_fady_dkhil/user/Settings/change_email.dart';
import 'package:ratrappage_fady_dkhil/user/Settings/change_name.dart';
import 'package:ratrappage_fady_dkhil/user/Settings/change_password.dart';
import 'package:ratrappage_fady_dkhil/user/Settings/change_phone.dart';
import 'package:ratrappage_fady_dkhil/user/Settings/change_username.dart';
import 'package:ratrappage_fady_dkhil/user/login.dart';
import 'package:ratrappage_fady_dkhil/user/profile_settings.dart';
import 'package:ratrappage_fady_dkhil/user/signup.dart';
import 'package:ratrappage_fady_dkhil/user_provider.dart'; // Import UserProvider
import 'color_schemes.g.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Add other providers if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        "/bag": (BuildContext context) => const Bag(),
        "/profile/settings": (BuildContext context) => const ProfileSettings(),
        "/settings": (BuildContext context) => const Settings(),
        "/settings/name": (BuildContext context) => const ChangeName(),
        "/settings/username": (BuildContext context) => const ChangeUsername(),
        "/settings/email": (BuildContext context) => const ChangeEmail(),
        "/settings/phone": (BuildContext context) => const ChangePhone(),
        "/settings/birth": (BuildContext context) => const ChangeBirth(),
        "/settings/password": (BuildContext context) => const ChangePassword(),
      },
    );
  }
}
