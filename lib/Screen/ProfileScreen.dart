import 'package:flutter/material.dart';
import '../Models/userdata_model.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Retrieve user data
    final userData = UserData();

    return Scaffold(
      appBar: AppBar(
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
