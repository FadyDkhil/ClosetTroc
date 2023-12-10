import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final TextEditingController _emailController = TextEditingController();
  late String userID;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
      // Fetch the user email when the widget is initialized
    });
    // You can perform initialization here if needed
  }

  Future<void> _changeEmail(String newEmail) async {
    try {
      final Map<String, String> headers = {'Content-Type': 'application/json'};
      final Map<String, dynamic> body = {'newEmail': newEmail};
      final response = await http.put(
        Uri.http("localhost:3000", "closettroc/users/$userID/email"),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Email changed successfully');
        // Optionally, you can update your local state or trigger a rebuild
      } else {
        print('Failed to change email: ${response.statusCode}');
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
        title: const Text('Change Email'),
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
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'New email',
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
                    final newEmail = _emailController.text;
                    print('Change button pressed with email: $newEmail');
                    _changeEmail(newEmail);
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
    _emailController.dispose();
    super.dispose();
  }
}
