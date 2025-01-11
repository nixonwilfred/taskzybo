import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  RxString name = ''.obs;
  RxString phone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData(); // Load data when the controller is initialized
  }

  // Save user data to SharedPreferences
  Future<void> saveUserData(String fullName, String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', fullName);
    await prefs.setString('user_phone', phoneNumber);
    name.value = fullName;
    phone.value = phoneNumber;
  }

  // Load user data from SharedPreferences
  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    name.value = prefs.getString('user_name') ?? 'Unknown';
    phone.value = prefs.getString('user_phone') ?? 'Unknown';
  }
}
