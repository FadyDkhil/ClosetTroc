import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../user_provider.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  String? _name;
  String? _userName;
  String? _oldPassword;
  String? _newPassword;
  String? _confirmPassword;
  String? _email;
  String? _phone;
  String? _birthDate;
  late String userID;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //get userID
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Settings"),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
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
                  border: OutlineInputBorder(), labelText: " Old Password"),
              onSaved: (String? newValue) {
                _oldPassword = newValue;
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
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: " New Password"),
              onSaved: (String? newValue) {
                _newPassword = newValue;
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
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: " Confirm Password"),
              onSaved: (String? newValue) {
                _confirmPassword = newValue;
              },
              validator: (String? value) {
                if (value == _newPassword) {
                  return "New password doesn't match!";
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
              child: const Text("Update Account"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Map<String, dynamic> eventData = {
                    "name": _name,
                    "username": _userName,
                    "password": _newPassword,
                    "email": _email,
                    "birth": _birthDate,
                    "phone": _phone,
                  };

                  Map<String, String> headers = {
                    "Content-Type": "application/json"
                    // "Content-Type": "application/json; charset=UTF-8"
                  };
                  http
                      .patch(
                          Uri.http(
                              "localhost:3000", "/closettroc/users/$userID"),
                          headers: headers,
                          body: json.encode(eventData))
                      .then((http.Response response) {
                    if (response.statusCode == 201) {
                      Navigator.pushReplacementNamed(context, "/home");
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
                              content: Text("Settings Changed Succesfully!"),
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
