import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'rai_estimasi_screen.dart';

class RaiProjectScreen extends StatefulWidget {
  const RaiProjectScreen({super.key});

  @override
  State<RaiProjectScreen> createState() => _RaiProjectScreenState();
}

class _RaiProjectScreenState extends State<RaiProjectScreen> {
  final _projectNameCtrl = TextEditingController();
  final _lokasiCtrl = TextEditingController();
  final _luasCtrl = TextEditingController();

  String? _selectedJenisBangunan;
  final List<String> _selectedRenovasi = [];

  final List<String> _jenisBangunanOptions = [
    'Rumah Tinggal',
    'Apartemen',
    'Ruko',
    'Kantor',
    'Kos-kosan',
    'Villa',
    'Lainnya',
  ];

  final List<Map<String, dynamic>> _jenisRenovasiOptions = [
    {'label': 'Dinding & Cat', 'icon': Icons.format_paint_rounded},
    {'label': 'Lantai', 'icon': Icons.layers_rounded},
    {'label': 'Plafon', 'icon': Icons.roofing_rounded},
    {'label': 'Kamar Mandi', 'icon': Icons.bathtub_rounded},
    {'label': 'Dapur', 'icon': Icons.kitchen_rounded},
    {'label': 'Pintu & Jendela', 'icon': Icons.door_front_door_rounded},
    {'label': 'Instalasi Listrik', 'icon': Icons.electrical_services_rounded},
    {'label': 'Atap', 'icon': Icons.home_rounded},
    {'label': 'Taman', 'icon': Icons.nature_rounded},
    {'label': 'Carport', 'icon': Icons.garage_rounded},
  ];

  bool get _isFormValid =>
      _projectNameCtrl.text.trim().isNotEmpty &&
      _lokasiCtrl.text.trim().isNotEmpty &&
      _selectedJenisBangunan != null &&
      _selectedRenovasi.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _projectNameCtrl.addListener(() => setState(() {}));
    _lokasiCtrl.addListener(() => setState(() {}));
    _luasCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _projectNameCtrl.dispose();
    _lokasiCtrl.dispose();
    _luasCtrl.dispose();
    super.dispose();
  }

  void _lanjutkanKeEstimasi() {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lengkapi semua field yang diperlukan'),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RaiEstimasiScreen(
          projectName: _projectNameCtrl.text.trim(),
          location: _lokasiCtrl.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.techWhite,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ─────────────────────────────────────────
            _buildHeader(context),

            // ─── Body ───────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Buat Project Baru',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.metallicBlack,
                        fontFamily: 'PPEditorialNew',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Isi detail project renovasimu untuk mendapatkan estimasi yang akurat.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.zenGray,
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Section 1: Identitas Project ──
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle(
                            icon: Icons.folder_rounded,
                            label: 'IDENTITAS PROJECT',
                          ),
                          const SizedBox(height: 16),

                          // Nama Project
                          _FieldLabel('NAMA PROJECT', required: true),
                          const SizedBox(height: 8),
                          _TextField(
                            controller: _projectNameCtrl,
                            hintText: 'cth: Renovasi Rumah Pak Budi',
                            prefixIcon: Icons.drive_file_rename_outline_rounded,
                          ),
                          const SizedBox(height: 16),

                          // Lokasi
                          _FieldLabel('LOKASI / KOTA', required: true),
                          const SizedBox(height: 8),
                          _TextField(
                            controller: _lokasiCtrl,
                            hintText: 'cth: Surabaya, Jawa Timur',
                            prefixIcon: Icons.location_on_rounded,
                          ),
                          const SizedBox(height: 16),

                          // Jenis Bangunan
                          _FieldLabel('JENIS BANGUNAN', required: true),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.techWhite,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedJenisBangunan,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 4),
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.home_work_rounded,
                                  size: 20,
                                  color: AppColors.zenGray,
                                ),
                              ),
                              hint: Text(
                                'Pilih jenis bangunan',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.zenGray.withOpacity(0.6),
                                  fontFamily: 'PPNeueMontrealMedium',
                                ),
                              ),
                              items: _jenisBangunanOptions
                                  .map((j) => DropdownMenuItem(
                                        value: j,
                                        child: Text(
                                          j,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.metallicBlack,
                                            fontFamily: 'PPNeueMontrealMedium',
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedJenisBangunan = v),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Luas Area
                          _FieldLabel('LUAS AREA', optional: true),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.techWhite,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 14),
                                  child: Icon(
                                    Icons.straighten_rounded,
                                    size: 18,
                                    color: AppColors.zenGray,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _luasCtrl,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.metallicBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'cth: 45',
                                      hintStyle: TextStyle(
                                        fontSize: 13,
                                        color:
                                            AppColors.zenGray.withOpacity(0.5),
                                        fontFamily: 'PPNeueMontrealMedium',
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 14),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: Text(
                                    'm²',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.zenGray,
                                      fontFamily: 'PPNeueMontrealMedium',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Section 2: Jenis Renovasi ──
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle(
                            icon: Icons.construction_rounded,
                            label: 'JENIS PEKERJAAN',
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pilih satu atau lebih pekerjaan yang akan dilakukan',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.zenGray,
                              fontFamily: 'PPNeueMontrealMedium',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _jenisRenovasiOptions.map((item) {
                              final label = item['label'] as String;
                              final icon = item['icon'] as IconData;
                              final selected =
                                  _selectedRenovasi.contains(label);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selected) {
                                      _selectedRenovasi.remove(label);
                                    } else {
                                      _selectedRenovasi.add(label);
                                    }
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.coconutGreen
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.coconutGreen
                                          : const Color(0xFFE0E0E0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        icon,
                                        size: 14,
                                        color: selected
                                            ? Colors.white
                                            : AppColors.zenGray,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: selected
                                              ? Colors.white
                                              : AppColors.metallicBlack,
                                          fontFamily: 'PPNeueMontrealMedium',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          if (_selectedRenovasi.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 14,
                                  color: AppColors.coconutGreen,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${_selectedRenovasi.length} pekerjaan dipilih',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.coconutGreen,
                                    fontFamily: 'PPNeueMontrealMedium',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── CTA Button ──
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: AnimatedOpacity(
                        opacity: _isFormValid ? 1.0 : 0.5,
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: _lanjutkanKeEstimasi,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.coconutGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.auto_awesome_rounded, size: 18),
                              const SizedBox(width: 10),
                              Text(
                                'Lanjut ke Estimasi',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'PPEditorialNew',
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Data project akan digunakan untuk estimasi biaya',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.zenGray,
                          fontFamily: 'PPNeueMontrealMedium',
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.techWhite,
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE8E8E8), width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColors.metallicBlack,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StepDot(label: 'PROJECT', step: 1, isActive: true, isDone: false),
                _StepLine(),
                _StepDot(label: 'ESTIMASI', step: 2, isActive: false, isDone: false),
                _StepLine(),
                _StepDot(label: 'HASIL', step: 3, isActive: false, isDone: false),
              ],
            ),
          ),
          // Balance spacer
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

// ─── Reusable Widgets ──────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: AppColors.metallicBlack.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionTitle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.coconutGreen),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.zenGray,
            letterSpacing: 0.8,
            fontFamily: 'PPNeueMontrealMedium',
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  final bool optional;

  const _FieldLabel(this.text, {this.required = false, this.optional = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.zenGray,
            letterSpacing: 0.8,
            fontFamily: 'PPNeueMontrealMedium',
          ),
        ),
        if (required)
          const Text(' *', style: TextStyle(color: Colors.red, fontSize: 12)),
        if (optional)
          Text(
            ' (OPSIONAL)',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.zenGray.withOpacity(0.6),
              fontFamily: 'PPNeueMontrealMedium',
            ),
          ),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;

  const _TextField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.techWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Icon(prefixIcon, size: 18, color: AppColors.zenGray),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.metallicBlack,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColors.zenGray.withOpacity(0.5),
                  fontFamily: 'PPNeueMontrealMedium',
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step Indicator Widgets ────────────────────────────────────────────────────

class _StepDot extends StatelessWidget {
  final String label;
  final int step;
  final bool isActive;
  final bool isDone;

  const _StepDot({
    required this.label,
    required this.step,
    required this.isActive,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone || isActive
                ? AppColors.coconutGreen
                : const Color(0xFFE0E0E0),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : AppColors.zenGray,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: isActive || isDone
                ? AppColors.metallicBlack
                : AppColors.zenGray,
            letterSpacing: 0.5,
            fontFamily: 'PPNeueMontrealMedium',
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 2,
      margin: const EdgeInsets.only(bottom: 14),
      color: const Color(0xFFE0E0E0),
    );
  }
}
