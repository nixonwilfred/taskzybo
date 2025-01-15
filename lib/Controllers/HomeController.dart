import 'package:get/get.dart';

import '../Models/Product_model.dart';
import '../Services/FetchWishListApi.dart';
import '../Services/fetchProducts.dart';
import '../Services/toggleWishlistApi.dart';
import '../Utilities/tokenStorage.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index; // Update the index
  }

  var productList = <Product>[].obs;

  Future<void> loadProducts() async {
    try {
      var products = await fetchProducts(); // Ensure fetchProducts is properly defined
      productList.assignAll(products);
    } catch (e) {
      Get.snackbar("Error", "Failed to load products: $e");
    }
  }
  var wishlist = <Product>[].obs; // Observable list of wishlist products

  // Load wishlist items from the API or filter locally
  Future<void> loadWishlist() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        Get.snackbar("Error", "Please log in to view your wishlist.");
        return;
      }
      var wishlistItems = await fetchWishlistAPI(token);
      wishlist.assignAll(wishlistItems);
      // Assuming `fetchProducts` is used here as a placeholder
    } catch (e) {
      Get.snackbar("Error", "Failed to load wishlist: $e");
    }
  }


  Future<void> manageWishlist(Product product) async {
    try {
      String? token = await TokenStorage.getToken(); // Retrieve the token
      if (token == null) {
        Get.snackbar("Error", "Please log in to use this feature.");
        return;
      }
      print("$token,${product.id}");


      final message = await toggleWishlistAPI(
          token, product.id); // Pass token to the API
      product.inWishlist = !product.inWishlist; // Update local state
      productList.refresh(); // Notify UI
      wishlist.assignAll(productList.where((p) => p.inWishlist).toList()); // Sync wishlist

      Get.snackbar("Wishlist", message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
