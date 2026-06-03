import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';// buat AppColors
import '../../core/providers/user_session_provider.dart';
import 'profile_setting_screen.dart';
import 'settings_screen.dart';
import 'notification_screen.dart';
import 'plan_screen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userSession = context.watch<UserSessionProvider>();
    final user = userSession.currentUser;
    final fullName = user != null
        ? "${user.firstName ?? user.name} ${user.lastName ?? ''}".trim()
        : "Guest User";
    final usernameOrEmail = user?.email ?? "guest@renovasim.com";

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary(context)),
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
                    child: const Icon(Icons.person, color: AppColors.coconutGreen),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'PPNeueMontrealMedium',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          usernameOrEmail,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // MENU LIST
            _menuItem(context, "My Account", Icons.person_outline_rounded, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProfileSettingScreen()),
              );
            }),

            _menuItem(context, "Project Dashboard", Icons.analytics_outlined, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const DashboardScreen()),
              );
            }),
            _menuItem(context, "Subscription Plan", Icons.star_outline_rounded, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PlanScreen()),
              );
            }),
            _menuItem(context, "Settings", Icons.settings_outlined, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const SettingsScreen()),
              );
            }),
            _menuItem(context, "Log out", Icons.logout_rounded, () {
              userSession.clearUser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const LoginScreen()),
              );
            }),
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