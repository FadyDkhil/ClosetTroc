import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ratrappage_fady_dkhil/Bag/bag_details.dart';
import 'dart:convert';
import 'package:ratrappage_fady_dkhil/Bag/bag_info.dart';

enum SearchCriteria { byName, byType }

class Bag extends StatefulWidget {
  const Bag({Key? key}) : super(key: key);

  @override
  State<Bag> createState() => _BagState();
}

class _BagState extends State<Bag> {
  late Future<void> _fetchedBag;
  final List<BagClass> _bag = [];

  Future<void> fetchBag() async {
    try {
      final Uri uri = Uri.http("localhost:3000", "/closettroc/bag", {});

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);

        if (jsonResponse is Map && jsonResponse.containsKey("bag")) {
          final List<dynamic> bagFromServer = jsonResponse["bag"];

          _bag.clear();

          bagFromServer.forEach((element) {
            _bag.add(BagClass(
              element["name"],
              element["type"],
              element["description"],
              element["price"],
              element["quantity"],
              element["size"],
              element["addedDate"],
              element["userID"],
            ));
          });
        } else {
          print("Invalid response format: Missing 'bag' key or not a Map.");
        }
      } else {
        print("Failed to load bag. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching bag: $error");
    }
  }

  @override
  void initState() {
    _fetchedBag = fetchBag();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bag"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _fetchedBag,
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else {
                  return GridView.builder(
                    itemCount: _bag.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => BagDetails(
                                      _bag[index].name,
                                      _bag[index].type,
                                      _bag[index].description,
                                      _bag[index].price,
                                      _bag[index].quantity,
                                      _bag[index].size,
                                      _bag[index].addedDate,
                                      _bag[index].userID))),
                          child: BagInfo(
                              _bag[index].name,
                              _bag[index].type,
                              _bag[index].description,
                              _bag[index].price,
                              _bag[index].quantity,
                              _bag[index].size,
                              _bag[index].addedDate,
                              _bag[index].userID));
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 140,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchedBag = fetchBag();
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class BagClass {
  String name;
  String type;
  String description;
  String price;
  String quantity;
  String size;
  String addedDate;
  String userID;

  BagClass(
    this.name,
    this.type,
    this.description,
    this.price,
    this.size,
    this.quantity,
    this.addedDate,
    this.userID,
  );
}
