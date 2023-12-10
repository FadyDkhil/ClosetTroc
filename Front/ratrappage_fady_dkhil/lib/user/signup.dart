import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? _name;
  String? _userName;
  String? _password;
  String? _email;
  String? _phone;
  String? _birthDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //get userID
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/logo.png', // Replace with your logo asset path
              width: 200,
              height: 150,
              // Adjust width and height as needed
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 2, 20, 20),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Full Name"),
              onSaved: (String? newValue) {
                _name = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Name mustn't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextFormField(
              // keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Username"),
              onSaved: (String? newValue) {
                _userName = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "You must choose a username";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Password"),
              onSaved: (String? newValue) {
                _password = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "password mustn't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextFormField(
              // keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Date of birth"),
              onSaved: (String? newValue) {
                _birthDate = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Date mustn't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextFormField(
              // keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Phone Number"),
              onSaved: (String? newValue) {
                _phone = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Phone mustn't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              child: const Text("Create Account"),
              onPressed: () {
                //add boolean if true add else error shows that username already exists
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Map<String, dynamic> eventData = {
                    "name": _name,
                    "username": _userName,
                    "password": _password,
                    "email": _email,
                    "birth": _birthDate,
                    "phone": _phone,
                  };

                  Map<String, String> headers = {
                    "Content-Type": "application/json"
                    // "Content-Type": "application/json; charset=UTF-8"
                  };
                  http
                      .post(Uri.http("localhost:3000", "/closettroc/users"),
                          headers: headers, body: json.encode(eventData))
                      .then((http.Response response) {
                    if (response.statusCode == 201) {
                      // Navigator.pushReplacementNamed(context, "/");
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) =>
                      //             const Events()));
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Information"),
                              content: Text("Account Created Succesfully!"),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Error"),
                              content: Text("An error occured"),
                            );
                          });
                    }
                  });
                }
              },
            ),
          ])
        ]),
      ),
    );
  }
}
