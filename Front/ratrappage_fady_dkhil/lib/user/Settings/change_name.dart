import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  final TextEditingController _nameController = TextEditingController();
  late String userID;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
      // Fetch the user name when the widget is initialized
    });
    // You can perform initialization here if needed
  }

  Future<void> _changeName(String newName) async {
    try {
      final Map<String, String> headers = {'Content-Type': 'application/json'};
      final Map<String, dynamic> body = {'newName': newName};
      final response = await http.put(
          Uri.http("localhost:3000", "closettroc/users/$userID/name"),
          headers: headers,
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        print('Name changed successfully');
        // Optionally, you can update your local state or trigger a rebuild
      } else {
        print('Failed to change name: ${response.statusCode}');
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
        title: const Text('Change Name'),
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
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'New name',
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
                    final newName = _nameController.text;
                    print('Change button pressed with name: $newName');
                    _changeName(newName);
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
    _nameController.dispose();
    super.dispose();
  }
}
