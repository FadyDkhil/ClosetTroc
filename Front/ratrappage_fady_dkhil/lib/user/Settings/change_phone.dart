import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../user_provider.dart';
import 'package:provider/provider.dart';

class ChangePhone extends StatefulWidget {
  const ChangePhone({Key? key}) : super(key: key);

  @override
  _ChangePhoneState createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+216'; // Default country code
  late String userID;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
      // Fetch the user phone number when the widget is initialized
    });
    // You can perform initialization here if needed
  }

  Future<void> _changePhone(String newPhoneNumber) async {
    try {
      final Map<String, String> headers = {'Content-Type': 'application/json'};
      final Map<String, dynamic> body = {'newPhoneNumber': newPhoneNumber};
      final response = await http.put(
        Uri.http("localhost:3000", "closettroc/users/$userID/phone"),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        _showDialog('Phone number changed successfully');
        // Optionally, you can update your local state or trigger a rebuild
      } else {
        print('Failed to change phone number: ${response.statusCode}');
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
        title: const Text('Change Phone Number'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCountryCode = newValue!;
                        });
                      },
                      items: <String>['+216 (Tunisia)', '+377 (Lithuania)']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value
                              .split(' ')[0], // Extracting the country code
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    width: 200, // Adjust the width as needed
                    child: TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        hintText: 'New phone number',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 16), // Adjust the height between input and button
              SizedBox(
                width: 200, // Adjust the width as needed
                child: ElevatedButton(
                  onPressed: () {
                    // Add your 'Change' button logic here
                    final newPhoneNumber =
                        '$_selectedCountryCode ${_phoneController.text}';
                    print(
                        'Change button pressed with phone number: $newPhoneNumber');
                    _changePhone(newPhoneNumber);
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
    _phoneController.dispose();
    super.dispose();
  }
}
