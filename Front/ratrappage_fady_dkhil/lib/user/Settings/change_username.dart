import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../user_provider.dart';
import 'package:provider/provider.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final TextEditingController _usernameController = TextEditingController();
  late String userID;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
      // Fetch the user username when the widget is initialized
    });
    // You can perform initialization here if needed
  }

  Future<void> _changeUsername(String newUsername) async {
    try {
      final Map<String, String> headers = {'Content-Type': 'application/json'};
      final Map<String, dynamic> body = {'newUsername': newUsername};
      final response = await http.put(
        Uri.http("localhost:3000", "closettroc/users/$userID/username"),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Username changed successfully');
        // Optionally, you can update your local state or trigger a rebuild
      } else {
        print('Failed to change username: ${response.statusCode}');
        // Handle error, you can show a snackbar or any other UI feedback
      }
    } catch (error) {
      print('Error: $error');
      // Handle network or other errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Username'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200, // Adjust the width as needed
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'New username',
                  ),
                ),
              ),
              const SizedBox(
                  height: 16), // Adjust the height between input and button
              SizedBox(
                width: 200, // Adjust the width as needed
                child: ElevatedButton(
                  onPressed: () {
                    // Add your 'Change' button logic here
                    final newUsername = _usernameController.text;
                    print('Change button pressed with username: $newUsername');
                    _changeUsername(newUsername);
                  },
                  child: const Text('Change'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
