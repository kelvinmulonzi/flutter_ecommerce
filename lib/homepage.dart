import 'package:ecommerce/apicall.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Assuming you have an ApiCall screen.

class HomePage extends StatelessWidget {
  // Method to fetch products from the FakeStore API
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      // Parse the response body
      List<dynamic> data = json.decode(response.body);
      return data.map((item) {
        return {
          "name": item['title'],
          "price": item['price'].toString(),
          "image": item['image'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("ShopEasy", style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Shop by Categories",
                    style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildCategoryCard("Electronics", Icons.devices),
                      buildCategoryCard("Fashion", Icons.style),
                      buildCategoryCard("Home", Icons.home_filled),
                      buildCategoryCard("Beauty", Icons.brush),
                      buildCategoryCard("Sports", Icons.sports),
                    ],
                  ),
                ),

                // Featured Products
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Featured Products",
                    style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                // Fetch and display the products from the API
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No products available"));
                    } else {
                      final products = snapshot.data!;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: products.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemBuilder: (context, index) {
                          return buildProductCard(products[index]);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          // Navigate to ApiCall Page Button (Fixed at the bottom)
          Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: ElevatedButton(
          onPressed: () {
          Get.to(ApiCall());  // Navigate to ApiCall page using GetX
          },
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange, // Changed color to something more vibrant
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Increased padding
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // More rounded corners for a modern look
          ),
          shadowColor: Colors.orangeAccent, // Added shadow for depth
          elevation: 8, // Elevated look for prominence
          ),
          child: Text(
          "GO TO MYSHOP",
    style: GoogleFonts.lato(
    fontWeight: FontWeight.bold,
    fontSize: 16, // Slightly increased font size for better visibility
    color: Colors.white, // White text to contrast the vibrant background
    ),
    ),
    ),
    ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        selectedItemColor: Colors.blueAccent,
      ),
    );
  }

  Widget buildCategoryCard(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Get.to(ApiCall()); // Navigate to ApiCall page when category is tapped
      },
      child: Container(
        width: 80,
        margin: EdgeInsets.only(right: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue[50],
              child: Icon(icon, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product['image'],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  "\$${product['price']}",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
