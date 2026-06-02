import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme_provider.dart';
import 'home_screen.dart';
import 'dashboard_screen.dart';

class AiCreateScreen extends StatefulWidget {
  const AiCreateScreen({super.key});

  @override
  State<AiCreateScreen> createState() => _AiCreateScreenState();
}

class _AiCreateScreenState extends State<AiCreateScreen> {
  int _selectedNav = 1;
  int _screenIndex = 0; // 0 = Mulai Estimasi, 1 = Buat Project, 2 = Hasil Estimasi

  // Form controllers
  final _projectNameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  String _selectedBuildingType = 'Rumah';

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.folder_copy_rounded, label: 'Projects'),
    _NavItem(icon: Icons.auto_awesome_rounded, label: 'AI Create'),
    _NavItem(icon: Icons.view_in_ar_rounded, label: '3D Design'),
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
  ];

  final List<String> _buildingTypes = [
    'Rumah',
    'Apartemen',
    'Ruko',
    'Kantor',
    'Villa',
    'Lainnya',
  ];

  @override
  void dispose() {
    _projectNameCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: _screenIndex == 0
            ? _BuildStartEstimationScreen(
                onNewProject: () => setState(() => _screenIndex = 1),
                onQuickEstimate: () {},
              )
            : _screenIndex == 1
                ? _BuildNewProjectScreen(
                    projectNameCtrl: _projectNameCtrl,
                    locationCtrl: _locationCtrl,
                    descriptionCtrl: _descriptionCtrl,
                    buildingTypes: _buildingTypes,
                    selectedBuildingType: _selectedBuildingType,
                    onBuildingTypeChanged: (value) {
                      setState(() => _selectedBuildingType = value);
                    },
                    onLanjutClick: () => setState(() => _screenIndex = 2),
                    onBackClick: () => setState(() => _screenIndex = 0),
                  )
                : _BuildEstimationResultScreen(
                    onBackClick: () => setState(() => _screenIndex = 0),
                    projectName: _projectNameCtrl.text,
                    location: _locationCtrl.text,
                  ),
      ),
      bottomNavigationBar: _BottomNav(
        items: _navItems,
        selectedIndex: _selectedNav,
        onTap: (i) {
          if (i == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (i == 1 || i == 2) {
            setState(() => _selectedNav = 1);
          } else if (i == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          }
        },
      ),
    );
  }
}

// ─── Screen 1: Mulai Estimasi ────────────────────────────────────────────────

class _BuildStartEstimationScreen extends StatelessWidget {
  final VoidCallback onNewProject;
  final VoidCallback onQuickEstimate;

  const _BuildStartEstimationScreen({
    required this.onNewProject,
    required this.onQuickEstimate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.coconutGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calculate_rounded,
              size: 40,
              color: AppColors.coconutGreen,
            ),
          ),
          const SizedBox(height: 24),
          // Title
          Text(
            'Mulai Estimasi',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary(context),
              fontFamily: 'PPEditorialNew',
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          Text(
            'Pilih bagaimana estimasi ini akan disimpan',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary(context),
              fontFamily: 'PPNeueMontrealMedium',
            ),
          ),
          const SizedBox(height: 40),
          // Option 1: New Project
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _EstimationOptionCard(
              icon: Icons.add_circle_outline_rounded,
              title: 'Buat project baru',
              subtitle: 'Mulai project renovasi baru dari awal',
              onTap: onNewProject,
            ),
          ),
          const SizedBox(height: 16),
          // Option 2: Quick Estimate
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _EstimationOptionCard(
              icon: Icons.flash_on_rounded,
              title: 'Estimasi cepat',
              subtitle: 'Hitung estimasi tanpa memasukkan ke project',
              onTap: onQuickEstimate,
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

// ─── Screen 2: Buat Project Baru ─────────────────────────────────────────────

class _BuildNewProjectScreen extends StatelessWidget {
  final TextEditingController projectNameCtrl;
  final TextEditingController locationCtrl;
  final TextEditingController descriptionCtrl;
  final List<String> buildingTypes;
  final String selectedBuildingType;
  final Function(String) onBuildingTypeChanged;
  final VoidCallback onLanjutClick;
  final VoidCallback onBackClick;

  const _BuildNewProjectScreen({
    required this.projectNameCtrl,
    required this.locationCtrl,
    required this.descriptionCtrl,
    required this.buildingTypes,
    required this.selectedBuildingType,
    required this.onBuildingTypeChanged,
    required this.onLanjutClick,
    required this.onBackClick,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBackClick,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Buat Project Baru',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                    fontFamily: 'PPEditorialNew',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Icon
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.coconutGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open_rounded,
                size: 30,
                color: AppColors.coconutGreen,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Subtitle
          Center(
            child: Text(
              'Isi detail project renovasmu, lalu pilih cara estimasi',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary(context),
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
          ),
          const SizedBox(height: 28),
          // Form
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Name
                Text(
                  'NAMA PROJECT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary(context),
                    letterSpacing: 0.8,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: projectNameCtrl,
                  decoration: InputDecoration(
                    hintText: 'Renovasi Rumah Pak Bud Bud',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary(context).withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.cardBackground(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.dividerColor(context),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.dividerColor(context),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 20),
                // Building Type
                Text(
                  'TIPE BANGUNAN (OPSIONAL)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary(context),
                    letterSpacing: 0.8,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: buildingTypes.length,
                  itemBuilder: (_, i) {
                    final isSelected = buildingTypes[i] == selectedBuildingType;
                    return GestureDetector(
                      onTap: () => onBuildingTypeChanged(buildingTypes[i]),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.coconutGreen
                              : AppColors.cardBackground(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.coconutGreen
                                : AppColors.dividerColor(context),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            buildingTypes[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary(context),
                              fontFamily: 'PPNeueMontrealMedium',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Location
                Text(
                  'LOKASI PROJECT (OPSIONAL)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary(context),
                    letterSpacing: 0.8,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: locationCtrl,
                  decoration: InputDecoration(
                    hintText: 'Surabaya',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary(context).withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.cardBackground(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.dividerColor(context),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.dividerColor(context),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 20),
                // Description
                Text(
                  'DESKRIPSI SINGKAT (OPSIONAL)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary(context),
                    letterSpacing: 0.8,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'misal: Renovasi total rumah 2 lantai, fokus dapur dan kamar mandi.',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary(context).withOpacity(0.5),
                      fontSize: 12,
                    ),
                    filled: true,
                    fillColor: AppColors.cardBackground(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.dividerColor(context),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.dividerColor(context),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 28),
                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onLanjutClick,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.coconutGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Lanjut ke Estimasi',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'PPNeueMontrealMedium',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Info text
                Center(
                  child: Text(
                    'Data project disimpan sementara hingga estimasi selesai',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary(context),
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Screen 3: Hasil Estimasi ────────────────────────────────────────────────

class _BuildEstimationResultScreen extends StatelessWidget {
  final VoidCallback onBackClick;
  final String projectName;
  final String location;

  const _BuildEstimationResultScreen({
    required this.onBackClick,
    required this.projectName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBackClick,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const Spacer(),
                Text(
                  'HASIL ESTIMASI'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary(context),
                    letterSpacing: 1.2,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              projectName.isNotEmpty ? projectName : 'RENOVASI RUMAH PAK BUD BUD',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary(context),
                fontFamily: 'PPEditorialNew',
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'MODE STANDARD – RENOVASI RUMAH PAK BUD BUD',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary(context),
                letterSpacing: 0.5,
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Alert boxes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Warning
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFFE69C),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: const Color(0xFFF39C12),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Asuransi yang mengira Ngini atau biaya asmai canggih nyin. Estimator ini nilai meskipun pleaser cpt discon dan span istilng',
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xFF856404),
                            fontFamily: 'PPNeueMontrealMedium',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Alert
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8D7DA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFF5C6CB),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        size: 20,
                        color: const Color(0xFFDC3545),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Budget halo ≥ 10,000,000 tetanggamu tidak ada untuk cek ini. Estimasi masimal  Rp 33,3/7.000',
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xFF721C24),
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
          const SizedBox(height: 24),
          // Total Cost Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.dividerColor(context),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL ESTIMATED COST',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary(context),
                      letterSpacing: 1.2,
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rp 33.3 juta – Rp 61.9 juta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.coconutGreen,
                      fontFamily: 'PPEditorialNew',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp 55.327.000 – Rp 61.904.375',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary(context),
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Confidence Level
                  Text(
                    'CONFIDENCE LEVEL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary(context),
                      letterSpacing: 1.2,
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.7,
                      minHeight: 8,
                      backgroundColor: AppColors.dividerColor(context),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.coconutGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Estimasi perlu halayak saume',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary(context),
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Breakdown by Type
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Breakdown by Type',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                    fontFamily: 'PPEditorialNew',
                  ),
                ),
                const SizedBox(height: 12),
                _BreakdownTable(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Project Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROJECT SUMMARY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary(context),
                    letterSpacing: 1.2,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                const SizedBox(height: 12),
                _SummaryItem(label: 'Label', value: location.isNotEmpty ? location : 'Lokasi'),
                _SummaryItem(label: 'Jenis Bangunan', value: 'Renovasi'),
                _SummaryItem(
                  label: 'Pengerjaan Dinding & Plafon, Pengerjaan Plafon, Pertukangan (Pintu Kayu), Lantai Vinyl / Parket, Instalasi Listrik',
                  value: '',
                  isLarge: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: onBackClick,
                  child: Text(
                    '← Estimasi Baru',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary(context),
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Simpan ke Project',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'PPNeueMontrealMedium',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helper Components ───────────────────────────────────────────────────────

class _EstimationOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _EstimationOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.dividerColor(context),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor(context),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.coconutGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: AppColors.coconutGreen,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary(context),
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textSecondary(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakdownTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          color: AppColors.dividerColor(context),
        ),
      ),
      children: [
        TableRow(
          children: [
            _TableCell('Pengerjaan Dinding & Plafon', isHeader: true),
            _TableCell('AREA 25 m²', isHeader: true, align: TextAlign.right),
            _TableCell('Rp 2.415.000 – Rp 3.622.500', isHeader: true, align: TextAlign.right),
          ],
        ),
        TableRow(
          children: [
            _TableCell('Pengerjaan Plafon'),
            _TableCell('AREA 25 m²', align: TextAlign.right),
            _TableCell('Rp 2.415.000 – Rp 3.622.500', align: TextAlign.right),
          ],
        ),
        TableRow(
          children: [
            _TableCell('Pertukangan (Pintu Kayu)'),
            _TableCell('AREA 25 m²', align: TextAlign.right),
            _TableCell('Rp 5.896.562 – Rp 11.771.125', align: TextAlign.right),
          ],
        ),
        TableRow(
          children: [
            _TableCell('Lantai Vinyl / Parket'),
            _TableCell('AREA 25 m²', align: TextAlign.right),
            _TableCell('Rp 11.582.000 – Rp 21.735.000', align: TextAlign.right),
          ],
        ),
        TableRow(
          children: [
            _TableCell('Instalasi Listrik'),
            _TableCell('AREA 25 m²', align: TextAlign.right),
            _TableCell('Rp 3.852.500 – Rp 14.191.875', align: TextAlign.right),
          ],
        ),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final TextAlign align;

  const _TableCell(
    this.text, {
    this.isHeader = false,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isHeader ? FontWeight.w700 : FontWeight.w400,
          color: isHeader
              ? AppColors.textPrimary(context)
              : AppColors.textSecondary(context),
          fontFamily: 'PPNeueMontrealMedium',
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isLarge;

  const _SummaryItem({
    required this.label,
    required this.value,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLarge)
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary(context),
                fontFamily: 'PPNeueMontrealMedium',
              ),
            )
          else
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: AppColors.coconutGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ─── Bottom Navigation ────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor(context),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = i == selectedIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[i].icon,
                        size: 22,
                        color: selected
                            ? AppColors.coconutGreen
                            : AppColors.textSecondary(context),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i].label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: selected
                              ? AppColors.coconutGreen
                              : AppColors.textSecondary(context),
                          fontFamily: 'PPNeueMontrealMedium',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Nav Item Model ───────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
