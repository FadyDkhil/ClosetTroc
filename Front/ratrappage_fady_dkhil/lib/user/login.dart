import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../user_provider.dart'; // Import your user_provider.dart file

class LogIn extends StatefulWidget {
  const LogIn({Key? key});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String? _userName;
  String? _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _login(BuildContext context) async {
    try {
      final response =
          await http.get(Uri.http("localhost:3000", "/closettroc/users"));

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);

        if (jsonResponse is Map && jsonResponse.containsKey("users")) {
          final List<dynamic> users = jsonResponse["users"];

          final user = users.firstWhere(
            (user) => user["username"] == _userName,
            orElse: () => null,
          );

          if (user != null && user["password"] == _password) {
            // Store the user _id using the provider
            // ignore: use_build_context_synchronously
            Provider.of<UserProvider>(context, listen: false)
                .setUserId(user["_id"]);

            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, "/home");
          } else {
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Error"),
                  content: Text("Invalid username or password"),
                );
              },
            );
          }
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text("Error"),
                content: Text(
                    "Invalid response format: Missing 'users' key or not a Map."),
              );
            },
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text("Error"),
              content: Text("Failed to fetch users from the server"),
            );
          },
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("An error occurred: $error"),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in"),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              '../assets/logo.png', // Replace with your logo asset path
              width: 200,
              height: 150,
              // Adjust width and height as needed
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 2, 20, 30),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Username"),
              onSaved: (String? newValue) {
                _userName = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Username mustn't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 2, 20, 30),
            child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Password"),
              onSaved: (String? newValue) {
                _password = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Password mustn't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: 460,
              height: 40,
              child: ElevatedButton(
                child: const Text("Login"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _login(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          title: Text("Error"),
                          content: Text("An error occurred"),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 460,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/signup");
                },
                child: const Text("Sign Up"),
              ),
            ),
          ])
        ]),
      ),
    );
  }
}
