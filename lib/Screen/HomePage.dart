import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Models/Banner_model.dart';
import '../Services/fetchBanners.dart';
import '../Models/Product_model.dart';
import '../Services/fetchProducts.dart';
import '../Controllers/HomeController.dart';
import 'ProfileScreen.dart'; // Import the controller

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController()); // Initialize the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex.value, // Reactively update the index
        children: [
          HomeScreen(), // Main Home Screen
          WishlistScreen(), // Wishlist Screen
          ProfileScreen(), // Profile Screen
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value, // Highlight the selected tab
        onTap: controller.changeIndex, // Update index on tap
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      )),
    );
  }
}

// Main Home Screen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          // Banner Slider
          FutureBuilder<List<BannerModel>>(
            future: fetchBanners(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No banners available'));
              } else {
                return CarouselSlider(
                  options: CarouselOptions(
                    height: screenHeight * 0.3,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: snapshot.data!.map((banner) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.05),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(screenWidth * 0.05),
                            child: CachedNetworkImage(
                              imageUrl: banner.imageUrl,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }
            },
          ),
          SizedBox(height: screenHeight * 0.02),
          // Popular Products Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Text(
              "Popular Products",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          // Product Grid
          FutureBuilder<List<Product>>(
            future: fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No products found'));
              } else {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 600 ? 3 : 2, // Responsive number of columns
                    crossAxisSpacing: screenWidth * 0.03,
                    mainAxisSpacing: screenWidth * 0.03,
                    childAspectRatio: screenWidth > 600 ? 4 / 5 : 3 / 4,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    final imageUrl = getImageUrl(product);

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text('₹${product.salePrice}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String getImageUrl(Product product) {
    if (product.addons.isNotEmpty) {
      return product.addons[0].featuredImage; // Use the first addon's image
    }
    return product.featuredImage; // Fallback to the featured image
  }
}

// Wishlist Screen
class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Text(
        "Wishlist Screen",
        style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Profile Screen

