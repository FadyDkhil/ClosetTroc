import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ratrappage_fady_dkhil/Bag/bag_details.dart';
import 'dart:convert';
import 'package:ratrappage_fady_dkhil/Bag/bag_info.dart';

import '../../../user_provider.dart';
import 'package:provider/provider.dart';

// add user provider ( juste zid filtre bel id mta user provider lel commands yani zid id fel database bch tfiltri aleha kif wahd iaady commande w zid'ha ilawj ken l9a andk commande deja twali andk +1 fel quantity)
// w kaml zid bouton louta mta proceed to payment
class Bag extends StatefulWidget {
  const Bag({Key? key}) : super(key: key);

  @override
  State<Bag> createState() => _BagState();
}

class _BagState extends State<Bag> {
  late Future<void> _fetchedBag;
  final List<BagClass> _bag = [];
  late String userID;

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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
    });
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
                  final List<BagClass> filteredBag =
                      _bag.where((bag) => bag.userID == userID).toList();

                  return GridView.builder(
                    itemCount: filteredBag.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => BagDetails(
                                      filteredBag[index].name,
                                      filteredBag[index].type,
                                      filteredBag[index].description,
                                      filteredBag[index].price,
                                      filteredBag[index].quantity,
                                      filteredBag[index].size,
                                      filteredBag[index].addedDate,
                                      filteredBag[index].userID))),
                          child: BagInfo(
                              filteredBag[index].name,
                              filteredBag[index].type,
                              filteredBag[index].description,
                              filteredBag[index].price,
                              filteredBag[index].quantity,
                              filteredBag[index].size,
                              filteredBag[index].addedDate,
                              filteredBag[index].userID));
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
          Container(
            margin: const EdgeInsets.fromLTRB(50, 15, 20, 5),
            child: SizedBox(
              width: 250,
              height: 45,
              child: ElevatedButton(
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Proceed to Payment", textScaleFactor: 1.25),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(40, 0, 0, 20),
            child: SizedBox(
              width: 150,
              height: 25,
              child: OutlinedButton(
                onPressed: () async {
                  try {
                    final response = await http
                        .delete(Uri.http("localhost:3000", "/closettroc/bag"));

                    if (response.statusCode == 203) {
                      Navigator.pushReplacementNamed(context, "/home");
                    } else {
                      // Handle error
                      print('Failed to delete product: ${response.body}');
                    }
                  } catch (error) {
                    // Handle network or other errors
                    print('Error: $error');
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Clear", textScaleFactor: 1),
                  ],
                ),
              ),
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
