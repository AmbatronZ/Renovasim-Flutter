import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  String? _selectedGender;
  bool _isEditMode = false;
  
  // Controllers for editing
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _birthDateCtrl;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: 'Rusdi');
    _lastNameCtrl = TextEditingController(text: 'Ambalan');
    _phoneCtrl = TextEditingController(text: '823 - 3042 - 7191');
    _birthDateCtrl = TextEditingController(text: '26 - Mei - 2006');
    _selectedGender = 'Laki-laki';
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _birthDateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                setState(() => _isEditMode = false);
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color: AppColors.coconutGreen,
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
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_firstNameCtrl.text} ${_lastNameCtrl.text}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary(context),
                            fontFamily: 'PPNeueMontrealMedium',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "@rusdi01gaming",
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

            // ─── EDIT SECTION ──────────────────────────────────
            if (_isEditMode) ...[
              _buildEditSection(context),
            ] else
              Center(
                child: Text(
                  'Tekan edit untuk mengubah data',
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditSection(BuildContext context) {
    return Column(
      children: [
        _input(context, "First Name", _firstNameCtrl),
        _input(context, "Last Name", _lastNameCtrl),
        _input(context, "Phone", _phoneCtrl),

        // Gender dropdown
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
              labelText: 'Gender',
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

        _input(context, "Birth Date", _birthDateCtrl),

        const SizedBox(height: 24),

        ElevatedButton(
          onPressed: () {
            // TODO: Save profile
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Profile updated successfully!'),
                backgroundColor: AppColors.coconutGreen,
              ),
            );
            setState(() => _isEditMode = false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.coconutGreen,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
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