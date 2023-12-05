import 'package:flutter/material.dart';
//import 'package:projet_camping_evenement/events/edit_event.dart';
import 'package:http/http.dart' as http;
import 'package:ratrappage_fady_dkhil/Shop/edit_product.dart';

class MyProductsInfo extends StatefulWidget {
  final String id;
  final String name;
  final String type;
  final String description;
  final String price;
  final String quantity;
  final String size;
  final String publishedDate;
  final String userID;

  const MyProductsInfo(
    this.id,
    this.name,
    this.type,
    this.description,
    this.price,
    this.quantity,
    this.size,
    this.publishedDate,
    this.userID,
  );

  @override
  _MyProductsInfoState createState() => _MyProductsInfoState();
}

class _MyProductsInfoState extends State<MyProductsInfo> {
  Future<void> deleteProduct() async {
    try {
      final response = await http.delete(
          Uri.http("localhost:3000", "/closettroc/products/${widget.id}"));

      if (response.statusCode == 203) {
        // The event was successfully deleted
        Navigator.pushReplacementNamed(context, "/home");
        //Navigator.pop(context); // You can navigate back or do any other action
      } else {
        // Handle error
        print('Failed to delete product: ${response.body}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        child: Column(
          children: [
            Text(widget.name),
            Text(widget.type),
            const SizedBox(
              height: 5,
            ),
            Text(widget.price),
            Text(widget.quantity),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        EditProduct(id: widget.id),
                  ),
                );
              },
              child: const Icon(Icons.edit),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: deleteProduct,
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
