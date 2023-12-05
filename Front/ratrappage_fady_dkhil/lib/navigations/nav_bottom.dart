import 'package:flutter/material.dart';
import 'package:ratrappage_fady_dkhil/Bag/bag.dart';
import 'package:ratrappage_fady_dkhil/Shop/Show/global/products.dart';
import 'package:ratrappage_fady_dkhil/Shop/Show/user/my_products.dart';
import 'package:ratrappage_fady_dkhil/user/login.dart';
import 'package:ratrappage_fady_dkhil/user/signup.dart';
//import 'package:http/http.dart' as http;
// import 'dart:convert';
//import '../user_provider.dart';
//import 'package:provider/provider.dart';
//import 'package:projet_camping_evenement/events/ShowEvents/events.dart';
//import 'package:projet_camping_evenement/shop/CampingMaterial.dart';

class NavBottom extends StatefulWidget {
  const NavBottom({super.key});

  @override
  State<NavBottom> createState() => _NavBottomState();
}

class _NavBottomState extends State<NavBottom> {
  int _currentIndex = 0;
  late String userID;
  late String nameOfUser = ""; // Variable to store the user name

  final List<Widget> _interfaces = const [Products(), Bag()];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //   userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";

    //   // Fetch the user name when the widget is initialized
    //   await fetchUserName();
    // });
  }

  // Future<void> fetchUserName() async {
  //   try {
  //     final response =
  //         await http.get(Uri.http("localhost:3000", "/fady/users/$userID"));

  //     if (response.statusCode == 200) {
  //       final dynamic jsonResponse = json.decode(response.body);

  //       if (jsonResponse is Map && jsonResponse.containsKey("userName")) {
  //         setState(() {
  //           nameOfUser = jsonResponse["userName"];
  //         });
  //       }
  //     } else if (response.statusCode == 404) {
  //       print("User not found");
  //     } else {
  //       print("Error fetching user name. Status code: ${response.statusCode}");
  //     }
  //   } catch (error) {
  //     print("Error fetching user name: $error");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Closet Troc"), // Display the user name in the app bar title
      ),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              title: const Text("nameOfUser"),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              title: const Row(children: [
                Icon(Icons.settings),
                SizedBox(
                  width: 10,
                ),
                Text("Account Settings"),
              ]),
              onTap: () {
                //Navigator.pushNamed(context, "/settings");
              },
            ),
            ListTile(
              title: const Row(children: [
                Icon(Icons.window),
                SizedBox(
                  width: 10,
                ),
                Text("My Products"),
              ]),
              onTap: () {
                Navigator.pushNamed(context, "/products/user");
              },
            ),
            ListTile(
              title: const Row(children: [
                Icon(Icons.sell),
                SizedBox(
                  width: 10,
                ),
                Text("Add Product"),
              ]),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/products/add");
              },
            ),
            // ListTile(
            //   title: const Row(children: [
            //     Icon(Icons.shopping_basket),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Text("Bag"),
            //   ]),
            //   onTap: () {
            //     //Navigator.pushNamed(context, "/events/followed");
            //   },
            // ),
            const SizedBox(
              height: 450,
            ),

            ListTile(
              title: const Row(children: [
                Icon(Icons.logout),
                SizedBox(
                  width: 10,
                ),
                Text("Log out"),
              ]),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/");
              },
            )
          ],
        ),
      ),
      body: _interfaces[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: "Bag",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.forum),
          //   label: "Forum",
          // )
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
