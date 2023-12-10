import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ratrappage_fady_dkhil/Shop/Show/global/products_details.dart';
import 'package:ratrappage_fady_dkhil/Shop/Show/global/products_info.dart';

enum SearchCriteria { byName, byType }

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  late Future<void> _fetchedProducts;
  final List<ProductsClass> _products = [];
  final TextEditingController _searchController = TextEditingController();
  SearchCriteria selectedSearchCriteria = SearchCriteria.byType;

  Future<void> fetchProducts({String? type, String? name}) async {
    try {
      final Uri uri = Uri.http("localhost:3000", "/closettroc/products", {
        if (selectedSearchCriteria == SearchCriteria.byType) "type": type,
        if (selectedSearchCriteria == SearchCriteria.byName) "name": name,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);

        if (jsonResponse is Map && jsonResponse.containsKey("products")) {
          final List<dynamic> productsFromServer = jsonResponse["products"];

          _products.clear();

          productsFromServer.forEach((element) {
            _products.add(ProductsClass(
              element["name"],
              element["type"],
              element["description"],
              element["price"],
              element["quantity"],
              element["size"],
              element["publishedDate"],
              element["userID"],
            ));
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

  @override
  void initState() {
    _fetchedProducts = fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Filter: "),
              Radio(
                value: SearchCriteria.byType,
                groupValue: selectedSearchCriteria,
                onChanged: (SearchCriteria? value) {
                  setState(() {
                    selectedSearchCriteria = value!;
                  });
                },
              ),
              const Text('Type'),
              Radio(
                value: SearchCriteria.byName,
                groupValue: selectedSearchCriteria,
                onChanged: (SearchCriteria? value) {
                  setState(() {
                    selectedSearchCriteria = value!;
                  });
                },
              ),
              const Text('Name'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: selectedSearchCriteria == SearchCriteria.byType
                    ? "Search by type"
                    : "Search by name",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _fetchedProducts = fetchProducts(
                      type: selectedSearchCriteria == SearchCriteria.byType
                          ? _searchController.text
                          : null,
                      name: selectedSearchCriteria == SearchCriteria.byName
                          ? _searchController.text
                          : null,
                    );
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          Expanded(
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
                  return GridView.builder(
                    itemCount: _products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProductsDetails(
                                      _products[index].name,
                                      _products[index].type,
                                      _products[index].description,
                                      _products[index].price,
                                      _products[index].quantity,
                                      _products[index].size,
                                      _products[index].publishedDate,
                                      _products[index].userID)),
                        ),
                        child: ProductsInfo(
                            _products[index].name,
                            _products[index].type,
                            _products[index].description,
                            _products[index].price,
                            _products[index].quantity,
                            _products[index].size,
                            _products[index].publishedDate,
                            _products[index].userID),
                      );
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
          _fetchedProducts = fetchProducts();
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class ProductsClass {
  String name;
  String type;
  String description;
  String price;
  String quantity;
  String size;
  String publishedDate;
  String userID;

  ProductsClass(
    this.name,
    this.type,
    this.description,
    this.price,
    this.size,
    this.quantity,
    this.publishedDate,
    this.userID,
  );
}
