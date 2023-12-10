import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ratrappage_fady_dkhil/Shop/edit_product.dart';

class MyProductsDetails extends StatefulWidget {
  final String _id;
  final String _name;
  final String _type;
  final String _description;
  final String _price;
  final String _quantity;
  final String _size;
  final String _publishedDate;
  final String _userID;

  const MyProductsDetails(
      this._id,
      this._name,
      this._type,
      this._description,
      this._price,
      this._quantity,
      this._size,
      this._publishedDate,
      this._userID);

  @override
  _MyProductsDetailsState createState() => _MyProductsDetailsState();
}

class _MyProductsDetailsState extends State<MyProductsDetails> {
  Future<void> deleteProduct() async {
    try {
      final response = await http.delete(
          Uri.http("localhost:3000", "/closettroc/products/${widget._id}"));

      if (response.statusCode == 203) {
        // The event was successfully deleted
        Navigator.pop(context); // You can navigate back or do any other action
      } else {
        // Handle error
        print('Failed to delete product: ${response.body}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  //late int _currentQuantity;
  @override
  void initState() {
    // _currentQuantity = widget._quantity;
    super.initState();
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
            margin: const EdgeInsets.fromLTRB(175, 30, 0, 30),
            child: Text("${widget._name} ", textScaleFactor: 2),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(175, 15, 0, 30),
            child: Text(widget._description),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(175, 15, 0, 30),
            child: Text("Price: ${widget._price}"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(175, 15, 0, 30),
            child: Text("Quantity: ${widget._quantity}"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(175, 15, 0, 30),
            child: Text("Size: ${widget._size}"),
          ),

          Container(
            margin: const EdgeInsets.fromLTRB(175, 15, 0, 15),
            child: SizedBox(
              width: 120,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => EditProduct(
                                id: widget._id,
                              )));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Edit")
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(175, 0, 0, 0),
            child: SizedBox(
              width: 120,
              height: 40,
              child: ElevatedButton(
                onPressed: deleteProduct,
                // onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Delete")
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
