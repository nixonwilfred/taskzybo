import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Models/userdata_model.dart';
import '../Utilities/tokenStorage.dart';
import 'LoginScreen.dart';

class ProfileScreen extends StatelessWidget {
  Future<void> logoutUser() async {
    await TokenStorage.deleteToken(); // Delete the stored token
    Get.offAll(() => LoginScreen()); // Navigate back to the LoginScreen
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Retrieve user data
    final userData = UserData();

    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(actions: [
        IconButton(padding: EdgeInsets.all(20),
          icon: Icon(Icons.logout, color: Colors.black), // Logout icon
          onPressed: () {
            // Log out action
            Get.defaultDialog(
              title: "Logout",
              middleText: "Are you sure you want to log out?",
              textCancel: "Cancel",
              textConfirm: "Logout",
              confirmTextColor: Colors.white,
              onConfirm: () {
                logoutUser();

              },
            );
          },
        ),
      ],

        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.04),
            Text(
              "Name",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              userData.name.isEmpty ? "Unknown" : userData.name,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Text(
              "Phone",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              userData.phone.isEmpty ? "Unknown" : userData.phone,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
