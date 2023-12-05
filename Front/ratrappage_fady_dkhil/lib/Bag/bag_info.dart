import 'package:flutter/material.dart';

class BagInfo extends StatelessWidget {
  final String name;
  final String type;
  final String description;
  final String price;
  final String quantity;
  final String size;
  final String addedDate;
  final String userID;

  const BagInfo(this.name, this.type, this.description, this.price,
      this.quantity, this.size, this.addedDate, this.userID);
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
            Text(addedDate),
          ],
        ),
      ),
    );
  }
}
