import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Models/Banner_model.dart';
import '../Services/fetchBanners.dart';
import '../Models/Product_model.dart';
import '../Services/fetchProducts.dart';
import '../Controllers/HomeController.dart';
import 'ProfileScreen.dart';


class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex.value,
        children: [
          HomeScreen(controller: controller,),
          WishlistScreen(
              controller:controller
          ),
          ProfileScreen(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      )),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final HomeController controller;
  HomeScreen({required this.controller});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      onRefresh: () async {
        await controller.loadProducts();
      },
      child: SingleChildScrollView(
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
            FutureBuilder<List<BannerModel>>(
              future: fetchBanners(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState("No banners available");
                } else {
                  return CarouselSlider(
                    options: CarouselOptions(
                      height: screenHeight * 0.2,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    items: snapshot.data!.map((banner) {
                      return GestureDetector(
                        onTap: () {
                          // Navigate to a banner details page or perf  orm an action
                          // Get.to(() => BannerDetailScreen(banner: banner));
                        },
                        child: Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.05),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(screenWidth * 0.04),
                            child: CachedNetworkImage(
                              imageUrl: banner.imageUrl,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: screenHeight * 0.02),
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
            FutureBuilder<List<Product>>(
              future: fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState("No products found");
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth > 600 ? 3 : 2,
                      crossAxisSpacing: screenWidth * 0.03,
                      mainAxisSpacing: screenWidth * 0.03,
                      childAspectRatio: screenWidth > 600 ? 4 / 5 : 3 / 4,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      final imageUrl = getImageUrl(product);

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(product.inWishlist ? Icons.favorite : Icons.favorite_border,),
                                color: product.inWishlist ? Colors.red : Colors.grey,
                                onPressed: () async {

                                await  controller.manageWishlist(product); // Use the updated controller method name
                                  },

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
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String getImageUrl(Product product) {
    if (product.addons.isNotEmpty) {
      return product.addons[0].featuredImage;
    }
    return product.featuredImage;
  }
}

class WishlistScreen extends StatelessWidget {
  final HomeController controller;
  WishlistScreen({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Obx((){
      if (controller.wishlist.isEmpty) {
        return Center(child: Text("Your wishlist is empty."));
      }
      return ListView.builder(
        itemCount: controller.wishlist.length,
        itemBuilder: (context, index) {
          final product = controller.wishlist[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('₹${product.salePrice}'),
            trailing: IconButton(
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: () async {
                controller.manageWishlist(product);
              },
          ),
          );
        },
      );
    });
  }
}

