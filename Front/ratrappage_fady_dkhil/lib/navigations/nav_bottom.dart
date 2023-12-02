import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';
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

  final List<Widget> _interfaces = const [
    // Events(),
    // CampingMaterial(),
    // Events()
  ];

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
            "Camping Project"), // Display the user name in the app bar title
      ),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              title: Text(nameOfUser),
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
                Navigator.pushNamed(context, "/settings");
              },
            ),
            ListTile(
              title: const Row(children: [
                Icon(Icons.window),
                SizedBox(
                  width: 10,
                ),
                Text("My Events"),
              ]),
              onTap: () {
                Navigator.pushNamed(context, "/my_events");
              },
            ),
            ListTile(
              title: const Row(children: [
                Icon(Icons.add_reaction),
                SizedBox(
                  width: 10,
                ),
                Text("Add Event"),
              ]),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/add_event");
              },
            ),
            ListTile(
              title: const Row(children: [
                Icon(Icons.follow_the_signs),
                SizedBox(
                  width: 10,
                ),
                Text("Subscribed Events"),
              ]),
              onTap: () {
                Navigator.pushNamed(context, "/events/followed");
              },
            ),
            ListTile(
              title: const Row(children: [
                Icon(Icons.storefront_sharp),
                SizedBox(
                  width: 10,
                ),
                Text("My Shop"),
              ]),
              onTap: () {
                Navigator.pushNamed(context, "/my_shop");
              },
            ),
            ListTile(
              title: const Row(children: [
                Icon(Icons.sell),
                SizedBox(
                  width: 10,
                ),
                Text("Sell"),
              ]),
              onTap: () {
                Navigator.pushNamed(context, "/shop/add");
              },
            ),
            const ListTile(),
            const ListTile(),
            const ListTile(),
            const ListTile(),
            const ListTile(),
            const ListTile(),
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
            icon: Icon(Icons.home),
            label: "Events",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: "Forum",
          )
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
