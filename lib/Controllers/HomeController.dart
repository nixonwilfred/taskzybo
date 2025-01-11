import 'package:get/get.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs; // Observable for the selected tab index

  void changeIndex(int index) {
    selectedIndex.value = index; // Update the index
  }
}
