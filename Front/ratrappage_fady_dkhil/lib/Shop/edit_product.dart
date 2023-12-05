import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import '../user_provider.dart';
// import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  final String id;
  const EditProduct({required this.id});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  String? _name;
  String? _type;
  String? _desc;
  String? _price;
  String? _quantity;
  String? _size;

  late String userID;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userID = "-1";
    // // Access context in initState by using a post-frame callback
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
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
                border: OutlineInputBorder(),
                labelText: "Name",
              ),
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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Type",
              ),
              onSaved: (String? newValue) {
                _type = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "You must choose a type";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Description",
              ),
              onSaved: (String? newValue) {
                _desc = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Description mustn't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Price",
              ),
              onSaved: (String? newValue) {
                _price = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "price mustn't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Quantity",
              ),
              onSaved: (String? newValue) {
                _quantity = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "quantity mustn't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Size",
              ),
              onSaved: (String? newValue) {
                _size = newValue;
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Size mustn't be empty";
                } else {
                  return null;
                }
              },
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              child: const Text("Edit Product"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Map<String, dynamic> eventData = {
                    "name": _name,
                    "type": _type,
                    "description": _desc,
                    "price": _price,
                    "quantity": _quantity,
                    "size": _size,
                    "publishedDate": DateTime.now().toString().split(' ')[0],
                    "userID": userID,
                  };

                  Map<String, String> headers = {
                    "Content-Type": "application/json; charset=UTF-8"
                  };

                  http
                      .patch(
                          Uri.http("localhost:3000",
                              "/closettroc/products/${widget.id}"),
                          body: json.encode(eventData),
                          headers: headers)
                      .then((http.Response response) {
                    if (response.statusCode == 202) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Information"),
                              content: Text("Product Changed Succesfully!"),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Information"),
                              content: Text("Product Changed Succesfully!"),
                            );
                          });
                    }
                  });
                }
              },
            ),
            const SizedBox(
              width: 20,
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ])
        ]),
      ),
    );
  }
}
