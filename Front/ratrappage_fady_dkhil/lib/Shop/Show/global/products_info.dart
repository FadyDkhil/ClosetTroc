import 'package:flutter/material.dart';

class ProductsInfo extends StatelessWidget {
  final String name;
  final String type;
  final String description;
  final String price;
  final String quantity;
  final String size;
  final String publishedDate;
  final String userID;

  const ProductsInfo(this.name, this.type, this.description, this.price,
      this.quantity, this.size, this.publishedDate, this.userID);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        child: Column(
          children: [
            Text(name),
            Text(type),
            const SizedBox(
              height: 5,
            ),
            Text(quantity),
            Text(size),
            Text(publishedDate),
          ],
        ),
      ),
    );
  }
}
