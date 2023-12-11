import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../user_provider.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late String userID;
  late String oldpass = "";
  bool showOldPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
      // Fetch the user password when the widget is initialized
      fetchOldPass();
    });
  }

  Future<void> _changePassword(String oldPassword, String newPassword) async {
    try {
      // Validate the old password (you might need to adjust this based on your authentication logic)
      final bool isOldPasswordCorrect = await _validateOldPassword(oldPassword);

      if (!isOldPasswordCorrect) {
        _showDialog('Old password is incorrect');
        return;
      }

      // Check if the new password and confirm password match
      if (_newPasswordController.text != _confirmPasswordController.text) {
        _showDialog('New password and confirm password do not match');
        return;
      }

      final Map<String, String> headers = {'Content-Type': 'application/json'};
      final Map<String, dynamic> body = {'newPassword': newPassword};
      final response = await http.put(
        Uri.http("localhost:3000", "closettroc/users/$userID/password"),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        _showDialog('Password changed successfully');
        // Optionally, you can update your local state or trigger a rebuild
      } else {
        _showDialog('Failed to change password: ${response.statusCode}');
      }
    } catch (error) {
      _showDialog('Error: $error');
    }
  }

  Future<void> fetchOldPass() async {
    try {
      final response = await http
          .get(Uri.http("localhost:3000", "/closettroc/users/$userID/getPass"));
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);

        if (jsonResponse is Map && jsonResponse.containsKey("userPass")) {
          setState(() {
            oldpass = jsonResponse["userPass"];
          });
        } else {
          print("Response does not contain a valid password field.");
        }
      } else if (response.statusCode == 404) {
        print("User not found");
      } else {
        print("Error fetching user. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching user: $error");
    }
  }

  Future<bool> _validateOldPassword(String oldPassword) async {
    try {
      // Compare the provided old password with the fetched old password
      return oldPassword == oldpass;
    } catch (error) {
      print("Error validating old password: $error");
      return false;
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
        title: const Text('Change Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _oldPasswordController,
                  obscureText: !showOldPassword,
                  decoration: InputDecoration(
                    hintText: 'Old password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        showOldPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showOldPassword = !showOldPassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _newPasswordController,
                  obscureText: !showNewPassword,
                  decoration: InputDecoration(
                    hintText: 'New password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        showNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showNewPassword = !showNewPassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: !showConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showConfirmPassword = !showConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your 'Change' button logic here
                    print("Fetched old password: $oldpass");

                    final oldPassword = _oldPasswordController.text;
                    final newPassword = _newPasswordController.text;
                    _changePassword(oldPassword, newPassword);
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
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
