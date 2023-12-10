import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../../user_provider.dart';

class ProductsDetails extends StatefulWidget {
  final String _name;
  final String _type;
  final String _description;
  final String _price;
  final String _quantity;
  final String _size;
  final String _publishedDate;
  final String _userID;

  const ProductsDetails(this._name, this._type, this._description, this._price,
      this._quantity, this._size, this._publishedDate, this._userID);

  @override
  _ProductsDetailsState createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  late String userID;
  //late int _currentQuantity;
  @override
  void initState() {
    // _currentQuantity = widget._quantity;
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._name),
      ),
      body: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          //   child: Image.asset(widget._image, width: 460, height: 215),
          // ),
          Container(
            margin: const EdgeInsets.fromLTRB(100, 50, 0, 30),
            child: Text("${widget._name} ", textScaleFactor: 2),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(100, 15, 0, 30),
            child: Text(widget._description),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(100, 15, 0, 30),
            child: Text("Posted: ${widget._publishedDate}"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(100, 0, 20, 50),
            child: Text("Quantity: ${widget._quantity}"),
          ),

          Container(
            margin: const EdgeInsets.fromLTRB(100, 0, 20, 50),
            child: Text("Price: ${widget._price}"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(100, 0, 20, 50),
            child: Text("Size: ${widget._size}"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(100, 15, 0, 0),
            child: SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> productData = {
                    "name": widget._name,
                    "type": widget._type,
                    "description": widget._description,
                    "price": widget._price,
                    "quantity": widget._quantity,
                    "size": widget._size,
                    "addedDate": DateTime.now().toString().split(' ')[0],
                    "userID": userID,
                  };

                  Map<String, String> headers = {
                    "Content-Type": "application/json",
                  };
                  http
                      .post(
                    Uri.http("localhost:3000", "/closettroc/bag"),
                    headers: headers,
                    body: json.encode(productData),
                  )
                      .then((http.Response response) {
                    if (response.statusCode == 201) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text("Information"),
                            content: Text("Added to Bag!"),
                          );
                        },
                      );
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
                  });
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_basket),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Add to Bag", textScaleFactor: 2),
                  ],
                ),
              ),
            ),
          ),

          // Container(
          //   margin: const EdgeInsets.fromLTRB(20, 20, 20, 50),
          //   child: Text("Exemplaire disponible: $_currentQuantity"),
          // ),
        ],
      ),
    );
  }
}
