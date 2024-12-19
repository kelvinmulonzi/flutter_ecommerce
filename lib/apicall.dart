import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// BaseOptions configuration for Dio
final options = BaseOptions(
  baseUrl: 'https://fakestoreapi.com/products',
  connectTimeout: const Duration(seconds: 5000),
);

Dio dio = Dio(options);

Future<List> getProducts() async {
  try {
    var response = await dio.get('');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(
          'Failed to load products. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    if (e is DioException) {
      print('DioException: ${e.message}');
    } else {
      print('Error: $e');
    }
    rethrow;
  }
}

Future<dynamic> getProductById(String id) async {
  print("Fetching product with: $id");
  try {
    var response = await dio.get('/$id');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(
          'Failed to fetch product. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print("Error from getProductById: $e");
    if (e is DioException) {
      print('DioException: ${e.message}');
    }
    rethrow;
  }
}

// Main widget
void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.teal, // Change primary color to Teal
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: ApiCall(),
  ));
}

class ApiCall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake Store API Products"),
        backgroundColor: Colors.teal, // Teal color for AppBar
      ),
      body: FutureBuilder<List>(
        future: getProducts(),
        builder: (context, snapshot) {
          // While loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // If error occurs
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // If data is successfully fetched
          else if (snapshot.hasData) {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/loading.gif', // Placeholder while loading image
                            image: product['image'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87, // Text color
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '\$${product['price']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green, // Price color
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Add to cart functionality or detail view
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Add to Cart'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No products found'));
          }
        },
      ),
    );
  }
}
