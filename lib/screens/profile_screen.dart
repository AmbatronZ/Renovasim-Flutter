import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';// buat AppColors
import 'profile_setting_screen.dart';
import 'notification_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontFamily: 'PPEditorialNew',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NotificationScreen(),
              ),
            );
          },  
        ),
        const SizedBox(width: 8),
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // USER CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.coconutGreen,
                    AppColors.thatchGreen,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rusdi Ambalan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'PPNeueMontrealMedium',
                        ),
                      ),
                      Text(
                        "@rusdi01gaming",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            // MENU LIST
            _menuItem(context, "My Account", Icons.person, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileSettingScreen()),
              );
            }),

            _menuItem(context, "Library Design", Icons.book, () {}),
            _menuItem(context, "Face ID / Touch ID", Icons.lock, () {}),
            _menuItem(context, "Two-Factor Authentication",
                Icons.security, () {}),
            _menuItem(context, "Log out", Icons.logout, () {}),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: AppColors.cardBackground(context),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: AppColors.textPrimary(context)),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'PPNeueMontrealMedium',
            color: AppColors.textPrimary(context),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary(context)),
        onTap: onTap,
      ),
    );
  }
}