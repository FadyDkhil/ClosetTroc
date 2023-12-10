import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../user_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String name = "";
  late String username;
  late String password;
  late String email;
  late String phone;
  late String birth;
  late String userID = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
      await fetchUserData();
    });
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
          Uri.http("localhost:3000", "/closettroc/users/userdata/$userID"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);

        setState(() {
          name = userData['name'];
          username = userData['username'];
          email = userData['email'];
          phone = userData['phone'];
          birth = userData['birth'];
        });
      } else {
        print('Failed to fetch user data: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Name: "),
                Text(name),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Username: "),
                Text(username),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Email: "),
                Text(email),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Phone: "),
                Text(phone),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Date of Birth: "),
                Text(birth),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/settings/name");
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(200, 30)),
              child: const Text("Change Name"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/settings/username");
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(200, 30)),
              child: const Text("Change Username"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/settings/email");
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(200, 30)),
              child: const Text("Change Email"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/settings/password");
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(200, 30)),
              child: const Text("Change Password"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/settings/birth");
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(200, 30)),
              child: const Text("Change Date of Birth"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/settings/phone");
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(200, 30)),
              child: const Text("Change Phone Number"),
            ),
          ],
        ),
      ),
    );
  }
}
