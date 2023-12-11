import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangeBirth extends StatefulWidget {
  const ChangeBirth({Key? key}) : super(key: key);

  @override
  _ChangeBirthState createState() => _ChangeBirthState();
}

class _ChangeBirthState extends State<ChangeBirth> {
  final TextEditingController _dobController = TextEditingController();
  late String userID;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
      // Fetch the user date of birth when the widget is initialized
    });
    // You can perform initialization here if needed
  }

  Future<void> _changeBirth(String newDOB) async {
    try {
      final Map<String, String> headers = {'Content-Type': 'application/json'};
      final Map<String, dynamic> body = {'newDOB': newDOB};
      final response = await http.put(
        Uri.http("localhost:3000", "closettroc/users/$userID/dob"),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        _showDialog('Date of birth changed successfully');

        // Optionally, you can update your local state or trigger a rebuild
      } else {
        print('Failed to change date of birth: ${response.statusCode}');
        // Handle error, you can show a snackbar or any other UI feedback
      }
    } catch (error) {
      print('Error: $error');
      // Handle network or other errors
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Date of Birth'),
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
                  controller: _dobController,
                  decoration: const InputDecoration(
                    hintText: 'New date of birth',
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
                    final newDOB = _dobController.text;
                    print('Change button pressed with date of birth: $newDOB');
                    _changeBirth(newDOB);
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
    _dobController.dispose();
    super.dispose();
  }
}
