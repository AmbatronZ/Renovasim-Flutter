import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'about_us_screen.dart';
import 'help_support_screen.dart';
import 'terms_conditions_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.techWhite,
      body: Stack(
        children: [
          // ─── Green header background ─────────────────────────────
          Container(
            height: 160,
            color: AppColors.thatchGreen,
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── AppBar row ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'My Account',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'PPEditorialNew',
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // ─── Profile Card ────────────────────────
                        Container(
                          margin:
                              const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.metallicBlack
                                    .withOpacity(0.07),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor:
                                    AppColors.coconutGreen.withOpacity(0.15),
                                child: const Icon(Icons.person_rounded,
                                    color: AppColors.coconutGreen, size: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Rusdi Ambalan',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.metallicBlack,
                                    fontFamily: 'PPEditorialNew',
                                  ),
                                ),
                              ),
                              const Icon(Icons.notifications_rounded,
                                  color: AppColors.coconutGreen, size: 22),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ─── Account Settings ────────────────────
                        _SectionLabel('Account Settings'),
                        const SizedBox(height: 6),
                        _SettingsCard(
                          children: [
                            _SettingsTile(
                              label: 'Edit profile',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ProfileScreen()),
                              ),
                            ),
                            _Divider(),
                            _SettingsTile(
                              label: 'Change password',
                              onTap: () {},
                            ),
                            _Divider(),
                            _SettingsTile(
                              label: 'Keamanan dan izin',
                              onTap: () {},
                            ),
                            _Divider(),
                            _SettingsTileSwitch(
                              label: 'Push notifications',
                              value: _pushNotifications,
                              onChanged: (v) =>
                                  setState(() => _pushNotifications = v),
                            ),
                            _Divider(),
                            _SettingsTileSwitch(
                              label: 'Dark mode',
                              value: _darkMode,
                              onChanged: (v) =>
                                  setState(() => _darkMode = v),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ─── More ────────────────────────────────
                        _SectionLabel('More'),
                        const SizedBox(height: 6),
                        _SettingsCard(
                          children: [
                           _SettingsTile(
                                label: 'About us',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                                ),
                              ),
                            _Divider(),
                          _SettingsTile(
                              label: 'Help & Support',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                              ),
                            ),
                            _Divider(),
                        _SettingsTile(
                            label: 'Terms and conditions',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TermsConditionsScreen()),
                            ),
                          ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ─── Log out ─────────────────────────────
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const LoginScreen()),
                                  (route) => false,
                                );
                              },
                              icon: const Icon(Icons.logout_rounded,
                                  color: Colors.red, size: 18),
                              label: Text(
                                'Log out',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                  fontFamily: 'PPNeueMontrealMedium',
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Colors.red, width: 1.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.zenGray,
          fontFamily: 'PPNeueMontrealMedium',
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.metallicBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.metallicBlack,
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.zenGray, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SettingsTileSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsTileSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.metallicBlack,
              fontFamily: 'PPNeueMontrealMedium',
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.coconutGreen,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.zenGray.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFF0F0F0),
    );
  }
}