import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// // import 'package:provider/provider.dart';
// import 'dart:convert';
// import '../../user_provider.dart';

class BagDetails extends StatefulWidget {
  final String _name;
  final String _type;
  final String _description;
  final String _price;
  final String _quantity;
  final String _size;
  final String _addedDate;
  final String _userID;

  const BagDetails(this._name, this._type, this._description, this._price,
      this._quantity, this._size, this._addedDate, this._userID);

  @override
  _BagDetailsState createState() => _BagDetailsState();
}

class _BagDetailsState extends State<BagDetails> {
  late String userID;
  //late int _currentQuantity;
  @override
  void initState() {
    // _currentQuantity = widget._quantity;
    super.initState();
    userID = "-1";
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
    // });
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
            child: Text("Added: ${widget._addedDate}"),
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

          // Container(
          //   margin: const EdgeInsets.fromLTRB(20, 20, 20, 50),
          //   child: Text("Exemplaire disponible: $_currentQuantity"),
          // ),
        ],
      ),
    );
  }
}
