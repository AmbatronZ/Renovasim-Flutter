import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

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
      body: Column(
        children: [
          // ─── Header ───────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.thatchGreen,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(0),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.settings_rounded,
                    color: Colors.white, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
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
                  // ─── Profile Card ────────────────────────────────
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.metallicBlack.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor:
                              AppColors.coconutGreen.withOpacity(0.2),
                          child: const Icon(Icons.person_rounded,
                              color: AppColors.coconutGreen, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rusdi Ambalan',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.metallicBlack,
                                  fontFamily: 'PPEditorialNew',
                                ),
                              ),
                              Text(
                                '@rusdi01gaming',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.zenGray,
                                  fontFamily: 'PPNeueMontrealMedium',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.notifications_rounded,
                            color: AppColors.coconutGreen, size: 22),
                      ],
                    ),
                  ),

                  // ─── Account Settings ────────────────────────────
                  _SectionLabel('Account Settings'),
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
                        onChanged: (v) => setState(() => _darkMode = v),
                      ),
                    ],
                  ),

                  // ─── More ────────────────────────────────────────
                  _SectionLabel('More'),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        label: 'About us',
                        onTap: () {},
                      ),
                      _Divider(),
                      _SettingsTile(
                        label: 'Help & Support',
                        onTap: () {},
                      ),
                      _Divider(),
                      _SettingsTile(
                        label: 'Terms and conditions',
                        onTap: () {},
                      ),
                    ],
                  ),

                  // ─── Logout ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
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
                          side: const BorderSide(color: Colors.red, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.zenGray,
          letterSpacing: 0.5,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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