import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ratrappage_fady_dkhil/Shop/Show/user/my_products_details.dart';
import 'package:ratrappage_fady_dkhil/Shop/Show/user/my_products_info.dart';
import '../../../user_provider.dart';
import 'package:provider/provider.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  final List<MyProductsClass> _products = [];
  late Future<void> _fetchedProducts;

  late String userID; // Declare userID as a late variable

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.http("localhost:3000", "/closettroc/products"));

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);

        if (jsonResponse is Map && jsonResponse.containsKey("products")) {
          final List<dynamic> productsFromServer = jsonResponse["products"];

          _products.clear();

          productsFromServer.forEach((element) {
            _products.add(MyProductsClass(
                element["_id"],
                element["name"],
                element["type"],
                element["description"],
                element["price"],
                element["quantity"],
                element["size"],
                element["publishedDate"],
                element["userID"]));
          });

          setState(() {
            print(_products.length);
          });
        } else {
          print(
              "Invalid response format: Missing 'products' key or not a Map.");
        }
      } else {
        print("Failed to load products. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching products: $error");
    }
  }

  Future<void> _refresh() async {
    await fetchProducts();
  }

  @override
  void initState() {
    _fetchedProducts = fetchProducts();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      userID = Provider.of<UserProvider>(context, listen: false).userId ?? "-1";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Access context here in the build method
    //userID = Provider.of<UserProvider>(context).userId ?? "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder(
          future: _fetchedProducts,
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
              final List<MyProductsClass> filteredProducts = _products
                  .where((products) => products.userID == userID)
                  .toList();

              return GridView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        //MyProductsInfo
                        builder: (BuildContext context) => MyProductsDetails(
                            filteredProducts[index].id,
                            filteredProducts[index].name,
                            filteredProducts[index].type,
                            filteredProducts[index].description,
                            filteredProducts[index].price,
                            filteredProducts[index].quantity,
                            filteredProducts[index].size,
                            filteredProducts[index].publishedDate,
                            filteredProducts[index].userID),
                      ),
                    ),
                    child: MyProductsInfo(
                        filteredProducts[index].id,
                        filteredProducts[index].name,
                        filteredProducts[index].type,
                        filteredProducts[index].description,
                        filteredProducts[index].price,
                        filteredProducts[index].quantity,
                        filteredProducts[index].size,
                        filteredProducts[index].publishedDate,
                        filteredProducts[index].userID),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 175,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/products/user");
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class MyProductsClass {
  String id;
  String name;
  String type;
  String description;
  String price;
  String quantity;
  String size;
  String publishedDate;
  String userID;

  MyProductsClass(this.id, this.name, this.type, this.description, this.price,
      this.quantity, this.size, this.publishedDate, this.userID);
}
