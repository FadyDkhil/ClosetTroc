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

class _LogInState extends State<LogIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<EdgeInsets> _logoAnimation;
  late Animation<double> _opacityAnimation;

  String? _userName;
  String? _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _logoAnimation = EdgeInsetsTween(
      begin: const EdgeInsets.only(top: 200),
      end: const EdgeInsets.only(top: 20),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

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
            Provider.of<UserProvider>(context, listen: false)
                .setUserId(user["_id"]);

            Navigator.pushReplacementNamed(context, "/home");
          } else {
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
      body: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: _logoAnimation.value,
                  child: Image.asset(
                    '../assets/logo.png',
                    width: 200,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: _opacityAnimation.value,
                  child: Container(
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
                ),
                AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: _opacityAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 2, 20, 30),
                    child: TextFormField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
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
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
