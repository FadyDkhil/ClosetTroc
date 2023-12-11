import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in_web/google_sign_in_web.dart';
//import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:grecaptcha/grecaptcha.dart';
import 'package:grecaptcha/grecaptcha_platform_interface.dart';

const String siteKey = "6LdeTy0pAAAAAAAfj2E-nhCVPaeTFMPjSUHpCyXb";

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

enum _VerificationStep { showingButton, working, error, verified }

enum _VerificationPlayServicesStep { initial, working, error, verified }

class _SignUpState extends State<SignUp> {
  String? _name;
  String? _userName;
  String? _password;
  String? _email;
  String? _phone;
  String? _birthDate;
  String _selectedCountryCode = '+216'; // Default country code

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  DateTime? _selectedDate;
  TextEditingController _birthDateController = TextEditingController();
  //
  _VerificationStep _step = _VerificationStep.showingButton;
  _VerificationPlayServicesStep _verifiedPlayServices =
      _VerificationPlayServicesStep.initial;

  void _startVerification() {
    setState(() => _step = _VerificationStep.working);

    Grecaptcha().verifyWithRecaptcha(siteKey).then((result) {
      /* When using reCaptcha in a production app, you would now send the $result
         to your backend server, so that it can verify it as well. In most
         cases, an ideal way to do this is sending it together with some form
         fields, for instance when creating a new account. Your backend server
         would then take the result field and make a request to the reCaptcha
         API to verify that the user of the device where the registration
         request is from is a human. It could then continue processing the
         request and complete the registration. */
      setState(() => _step = _VerificationStep.verified);
    }, onError: (e, s) {
      if (kDebugMode) {
        print("Could not verify:\n$e at $s");
      }
      setState(() => _step = _VerificationStep.error);
    });
  }

  void _startVerificationPlayServiceMethod1() {
    setState(
        () => _verifiedPlayServices = _VerificationPlayServicesStep.working);

    Grecaptcha().isAvailable.then((result) {
      setState(
          () => _verifiedPlayServices = _VerificationPlayServicesStep.verified);
    }, onError: (e, s) {
      if (kDebugMode) {
        print("Could not verify:\n$e at $s");
      }
      setState(
          () => _verifiedPlayServices = _VerificationPlayServicesStep.error);
    });
  }

  void _startVerificationPlayServiceMethod2() {
    setState(
        () => _verifiedPlayServices = _VerificationPlayServicesStep.working);

    Grecaptcha().googlePlayServicesAvailability().then((result) {
      if (result == GooglePlayServicesAvailability.success) {
        setState(() =>
            _verifiedPlayServices = _VerificationPlayServicesStep.verified);
      } else {
        setState(
            () => _verifiedPlayServices = _VerificationPlayServicesStep.error);
      }
    }, onError: (e, s) {
      if (kDebugMode) {
        print("Could not verify:\n$e at $s");
      }
      setState(
          () => _verifiedPlayServices = _VerificationPlayServicesStep.error);
    });
  }

  //
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Format the date if needed
        _birthDate = "${picked.year}-${picked.month}-${picked.day}";
      });

      // Update the input field with the selected date
      final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
      _birthDateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_step) {
      case _VerificationStep.showingButton:
        content = const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: []);
        break;
      case _VerificationStep.working:
        content = const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text("Trying to figure out whether you're human"),
            ]);
        break;
      case _VerificationStep.verified:
        content = const Text(
            "The reCaptcha API returned a token, indicating that you're a human. "
            "In real world use case, you would send use the token returned to "
            "your backend-server so that it can verify it as well.");
        break;
      case _VerificationStep.error:
        content = const Text("you have no internet connection .");
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                content,
                const SizedBox(
                  height: 5,
                ),
                _verifiedPlayServices == _VerificationPlayServicesStep.working
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/logo.png', // Replace with your logo asset path
              width: 200,
              height: 150,
              // Adjust width and height as needed
            ),
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
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
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: TextFormField(
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
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Email"),
              onSaved: (String? newValue) {
                _email = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "You must choose an email";
                } else if (!RegExp(
                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                    .hasMatch(value)) {
                  return "Invalid email format";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: TextFormField(
              obscureText: !showPassword,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
              ),
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
          Row(
            children: [
              Container(
                width: 150,
                margin: const EdgeInsets.fromLTRB(20, 0, 10, 5),
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
                      value: value.split(' ')[0], // Extracting the country code
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.fromLTRB(0, 0, 20, 5),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Phone Number"),
                  onSaved: (String? newValue) {
                    _phone = '$_selectedCountryCode$newValue';
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
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: TextFormField(
              readOnly: true,
              onTap: () => _selectDate(context),
              controller: _birthDateController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Date of birth"),
              validator: (String? value) {
                if (_selectedDate == null) {
                  return "Please select a date of birth";
                } else {
                  return null;
                }
              },
            ),
          ),
          MaterialButton(
            onPressed: _startVerification,
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: const Text("VERIFY RECAPTCHA"),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              child: const Text("Create Account"),
              onPressed: () {
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
                  };
                  http
                      .post(Uri.http("localhost:3000", "/closettroc/users"),
                          headers: headers, body: json.encode(eventData))
                      .then((http.Response response) {
                    if (response.statusCode == 201) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Information"),
                              content: Text("Account Created Successfully!"),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Error"),
                              content: Text("An error occurred"),
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

/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

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
  String _selectedCountryCode = '+216'; // Default country code

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  DateTime? _selectedDate;
  TextEditingController _birthDateController = TextEditingController();

  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDate = "${picked.year}-${picked.month}-${picked.day}";
      });

      final formattedDate = "${picked.day}/${picked.month}/${picked.year}";
      _birthDateController.text = formattedDate;
    }
  }

  Future<void> _showCaptcha() async {
    try {
      await _googleSignIn.signIn();
      _submitForm();
    } catch (error) {
      print("reCAPTCHA verification failed: $error");
    }
  }

  Future<void> _submitForm() async {
    final Map<String, dynamic> eventData = {
      "name": _name,
      "username": _userName,
      "password": _password,
      "email": _email,
      "birth": _birthDate,
      "phone": _phone,
    };

    final Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      final http.Response response = await http.post(
        Uri.http("localhost:3000", "/closettroc/users"),
        headers: headers,
        body: json.encode(eventData),
      );

      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text("Information"),
              content: Text("Account Created Successfully!"),
            );
          },
        );
      } else {
        // ignore: use_build_context_synchronously
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
    } catch (error) {
      print("Error during signup: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/logo.png',
                width: 200,
                height: 150,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 2, 20, 10),
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
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextFormField(
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
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Email"),
                onSaved: (String? newValue) {
                  _email = newValue;
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "You must choose an email";
                  } else if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                      .hasMatch(value)) {
                    return "Invalid email format";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextFormField(
                obscureText: !showPassword,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
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
            Row(
              children: [
                Container(
                  width: 150,
                  margin: const EdgeInsets.fromLTRB(20, 0, 10, 10),
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
                        value:
                            value.split(' ')[0], // Extracting the country code
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: 300,
                  margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Phone Number"),
                    onSaved: (String? newValue) {
                      _phone = '$_selectedCountryCode$newValue';
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
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: TextFormField(
                readOnly: true,
                onTap: () => _selectDate(context),
                controller: _birthDateController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Date of birth"),
                validator: (String? value) {
                  if (_selectedDate == null) {
                    return "Please select a date of birth";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _showCaptcha,
                  child: const Text("Create Account"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

*/
