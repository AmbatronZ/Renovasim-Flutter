import 'package:flutter/material.dart';
import 'home_screen.dart';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.techWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.metallicBlack),
        title: Text(
          "My Account",
          style: TextStyle(
            color: AppColors.metallicBlack,
            fontFamily: 'PPEditorialNew',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.coconutGreen,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "Rusdi Ambalan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
            Text("@rusdi01gaming"),
            SizedBox(height: 20),

            _input("First Name", "Rusdi"),
            _input("Last Name", "Ambalan"),
            _input("Phone", ""),
            _input("Gender", ""),
            _input("Birth Date", "26 - Mei - 2006"),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coconutGreen,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Update Profile",
                style: TextStyle(
                  fontFamily: 'PPNeueMontrealMedium',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _input(String label, String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}