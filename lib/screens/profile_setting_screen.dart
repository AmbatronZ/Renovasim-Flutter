import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/user_session_provider.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  String? _selectedGender;
  bool _isEditMode = false;
  bool _isSaving = false;
  
  // Controllers for editing
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _birthDateCtrl;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _birthDateCtrl = TextEditingController();
    _selectedGender = null;

    // Populate form from the provider after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final user = context.read<UserSessionProvider>().currentUser;
    if (user != null) {
      setState(() {
        _firstNameCtrl.text = user.firstName ?? '';
        _lastNameCtrl.text = user.lastName ?? '';
        _phoneCtrl.text = user.phone ?? '';
        // Gender and BirthDate are local-only for now
      });
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _birthDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);

    final userSession = context.read<UserSessionProvider>();

    try {
      await userSession.updateProfile(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
      );

      if (!mounted) return;

      if (userSession.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal update: ${userSession.error}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: AppColors.coconutGreen,
          ),
        );
        setState(() => _isEditMode = false);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSessionProvider>(
      builder: (context, userSession, _) {
        final user = userSession.currentUser;
        final displayName = user != null
            ? '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim()
            : 'User';
        final displayEmail = user?.email ?? '-';

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground(context),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(color: AppColors.textPrimary(context)),
            title: Text(
              "My Account",
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontFamily: 'PPEditorialNew',
              ),
            ),
            actions: [
              if (_isEditMode)
                TextButton(
                  onPressed: _isSaving ? null : () {
                    setState(() => _isEditMode = false);
                    _loadUserData(); // Reset to server data
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ─── USER INFO (Display Only) ───────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground(context),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor(context),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.coconutGreen,
                        child: Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName.isNotEmpty ? displayName : 'User',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary(context),
                                fontFamily: 'PPNeueMontrealMedium',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              displayEmail,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!_isEditMode)
                        IconButton(
                          icon: const Icon(Icons.edit_rounded),
                          color: AppColors.coconutGreen,
                          onPressed: () => setState(() => _isEditMode = true),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ─── ACCOUNT INFO (Read-Only) ─────────────────────
                if (!_isEditMode) ...[
                  _readOnlyTile(context, 'Email', displayEmail, Icons.email_outlined),
                  _readOnlyTile(context, 'Phone', user?.phone ?? '-', Icons.phone_outlined),
                  _readOnlyTile(context, 'Role', user?.role ?? '-', Icons.badge_outlined),
                  _readOnlyTile(context, 'Timezone', user?.timezone ?? '-', Icons.access_time_outlined),
                  _readOnlyTile(context, 'Language', user?.language ?? '-', Icons.language_outlined),
                  _readOnlyTile(context, 'Job Title', user?.jobTitle ?? '-', Icons.work_outline),
                  const SizedBox(height: 12),
                  Text(
                    'Tekan edit untuk mengubah data',
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                  ),
                ],

                // ─── EDIT SECTION ──────────────────────────────────
                if (_isEditMode) ...[
                  _buildEditSection(context),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _readOnlyTile(BuildContext context, String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textSecondary(context).withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.coconutGreen, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditSection(BuildContext context) {
    return Column(
      children: [
        _input(context, "First Name", _firstNameCtrl),
        _input(context, "Last Name", _lastNameCtrl),
        _input(context, "Phone", _phoneCtrl),

        // Gender dropdown (local-only)
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground(context),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.textSecondary(context).withOpacity(0.3),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              labelText: 'Gender (lokal)',
              labelStyle: TextStyle(color: AppColors.textPrimary(context)),
              filled: true,
              fillColor: AppColors.cardBackground(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Laki-laki',
                child: Text('Laki-laki'),
              ),
              DropdownMenuItem(
                value: 'Perempuan',
                child: Text('Perempuan'),
              ),
            ],
            onChanged: (value) {
              setState(() => _selectedGender = value);
            },
            hint: Text(
              'Pilih gender',
              style: TextStyle(color: AppColors.textSecondary(context)),
            ),
          ),
        ),

        _input(context, "Birth Date (lokal)", _birthDateCtrl),

        const SizedBox(height: 24),

        ElevatedButton(
          onPressed: _isSaving ? null : _saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.coconutGreen,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isSaving
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Text(
                  "Update Profile",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
        ),
      ],
    );
  }

  Widget _input(BuildContext context, String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: TextStyle(color: AppColors.textPrimary(context)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.textSecondary(context)),
          filled: true,
          fillColor: AppColors.cardBackground(context),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.textSecondary(context).withOpacity(0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.textSecondary(context).withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.coconutGreen,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}