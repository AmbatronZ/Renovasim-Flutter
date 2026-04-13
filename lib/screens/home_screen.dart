// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/renovation_models.dart';
import 'project_detail_screen.dart';
import 'manage_payment_screen.dart';

// ─── Color Palette ───────────────────────────────────────────────────────────
class AppColors {
  static const techWhite = Color(0xFFF5F5F5);
  static const zenGray = Color(0xFF747473);
  static const coconutGreen = Color(0xFF8BA023);
  static const thatchGreen = Color(0xFF3B411E);
  static const metallicBlack = Color(0xFF2C2C2B);
  static const white = Colors.white;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNav = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.folder_copy_rounded, label: 'Projects'),
    _NavItem(icon: Icons.auto_awesome_rounded, label: 'AI Create'),
    _NavItem(icon: Icons.map_outlined, label: 'Plan'),
    _NavItem(icon: Icons.settings_rounded, label: 'Config'),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: AppColors.techWhite,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _HeroBanner(),
                    const SizedBox(height: 28),
                    _PortfolioSection(),
                    const SizedBox(height: 24),
                    _BudgetInsightCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        items: _navItems,
        selectedIndex: _selectedNav,
        onTap: (i) => setState(() => _selectedNav = i),
      ),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/renovasim_logo.svg',
            height: 32,
          ),
          const Spacer(),
          _IconBtn(icon: Icons.notifications_outlined),
          const SizedBox(width: 4),
          _IconBtn(icon: Icons.settings_outlined),
          const SizedBox(width: 4),
          _IconBtn(icon: Icons.person_outline_rounded),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  const _IconBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 22, color: AppColors.metallicBlack),
      ),
    );
  }
}

// ─── Hero Banner ─────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 260,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/background1.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.thatchGreen,
                        AppColors.metallicBlack,
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.65),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Rencanakan\nRenovasi Rumah mu\nDengan ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.3,
                              fontFamily: 'PPEditorialNew',
                            ),
                          ),
                          TextSpan(
                            text: 'RenovaSim',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.coconutGreen,
                              fontStyle: FontStyle.italic,
                              height: 1.3,
                              fontFamily: 'PPEditorialNew',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Renovasi rumah melalui simulasi\nvisual dan estimasi biaya berbasis data',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.5,
                        fontFamily: 'PPNeue Montreal',
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.coconutGreen,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_circle_outline_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Start New Project',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'PPNeueMontrealMedium',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Portfolio Section ────────────────────────────────────────────────────────
class _PortfolioSection extends StatelessWidget {
  // Data dummy proyek yang akan digunakan di detail
  static final List<RenovationProject> _dummyProjects = [
    // Scandinavian Room
    RenovationProject(
      id: 'proj-001',
      projectName: 'Scandinavian Room',
      description:
          'Renovasi ruang tamu bergaya Skandinavia dengan sentuhan minimalis, fokus pada pencahayaan alami dan material kayu.',
      items: [
        RenovationItem(
          id: '1',
          name: 'Cat Tembok Putih',
          description: 'Cat interior premium',
          category: MaterialCategory.paint,
          quantity: 3,
          unit: 'galon',
          unitPrice: 280000,
          isEssential: true,
        ),
        RenovationItem(
          id: '2',
          name: 'Lantai Parket Kayu',
          description: 'Parket solid oak',
          category: MaterialCategory.wood,
          quantity: 25,
          unit: 'm²',
          unitPrice: 350000,
          isEssential: true,
        ),
        RenovationItem(
          id: '3',
          name: 'Lampu Gantung',
          description: 'Desain minimalis',
          category: MaterialCategory.electric,
          quantity: 2,
          unit: 'pcs',
          unitPrice: 450000,
          isEssential: false,
        ),
        RenovationItem(
          id: '4',
          name: 'Tenaga Tukang',
          description: 'Upah harian',
          category: MaterialCategory.labor,
          quantity: 15,
          unit: 'hari',
          unitPrice: 200000,
          isEssential: true,
        ),
      ],
      recommendations: [
        PriceRecommendation(
          itemId: '1',
          itemName: 'Cat Tembok Putih',
          currentPrice: 280000,
          recommendedPrice: 250000,
          savingPercentage: 10.7,
          reason: 'Supplier lokal menawarkan diskon untuk pembelian 3 galon.',
          supplier: 'Toko Cat Maju',
        ),
      ],
      costCuttingRecs: [
        CostCuttingRecommendation(
          title: 'Ganti Lampu Gantung dengan Downlight',
          description: 'Lebih hemat dan fungsional',
          potentialSaving: 600000,
          priority: 'medium',
          category: 'Listrik',
          suggestions: ['Downlight LED 12W', 'Lampu panel persegi'],
        ),
      ],
      costBreakdown: CostBreakdown(
        essentialCost: 9590000,
        optionalCost: 900000,
        laborCost: 3000000,
        discountAmount: 300000,
        tax: 674500,
        adminFee: 100000,
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    // Futuristic Office
    RenovationProject(
      id: 'proj-002',
      projectName: 'Futuristic Office',
      description:
          'Desain kantor modern dengan konsep futuristik, menggunakan material metalik dan kaca.',
      items: [
        RenovationItem(
          id: '5',
          name: 'Partisi Kaca',
          description: 'Kaca tempered 10mm',
          category: MaterialCategory.wood,
          quantity: 12,
          unit: 'm²',
          unitPrice: 750000,
          isEssential: true,
        ),
        RenovationItem(
          id: '6',
          name: 'Lantai Vinyl',
          description: 'Motif beton',
          category: MaterialCategory.tile,
          quantity: 40,
          unit: 'm²',
          unitPrice: 120000,
          isEssential: true,
        ),
        RenovationItem(
          id: '7',
          name: 'Lampu LED Strip',
          description: 'RGB smart',
          category: MaterialCategory.electric,
          quantity: 10,
          unit: 'meter',
          unitPrice: 85000,
          isEssential: false,
        ),
        RenovationItem(
          id: '8',
          name: 'Tenaga Tukang',
          description: 'Upah harian',
          category: MaterialCategory.labor,
          quantity: 20,
          unit: 'hari',
          unitPrice: 220000,
          isEssential: true,
        ),
      ],
      recommendations: [],
      costCuttingRecs: [],
      costBreakdown: CostBreakdown(
        essentialCost: 13800000,
        optionalCost: 850000,
        laborCost: 4400000,
        discountAmount: 0,
        tax: 952500,
        adminFee: 150000,
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    // Matte Kitchen
    RenovationProject(
      id: 'proj-003',
      projectName: 'Matte Kitchen',
      description:
          'Dapur dengan finishing matte, kabinet kayu, dan backsplash keramik.',
      items: [
        RenovationItem(
          id: '9',
          name: 'Kabinet Bawah',
          description: 'Kayu lapis finishing matte',
          category: MaterialCategory.wood,
          quantity: 4,
          unit: 'unit',
          unitPrice: 1200000,
          isEssential: true,
        ),
        RenovationItem(
          id: '10',
          name: 'Keramik Dinding',
          description: '20x25 cm matte',
          category: MaterialCategory.tile,
          quantity: 15,
          unit: 'm²',
          unitPrice: 220000,
          isEssential: true,
        ),
        RenovationItem(
          id: '11',
          name: 'Kran Wastafel',
          description: 'Stainless steel',
          category: MaterialCategory.plumbing,
          quantity: 1,
          unit: 'pcs',
          unitPrice: 450000,
          isEssential: true,
        ),
        RenovationItem(
          id: '12',
          name: 'Tenaga Tukang',
          description: 'Upah borongan',
          category: MaterialCategory.labor,
          quantity: 1,
          unit: 'paket',
          unitPrice: 5000000,
          isEssential: true,
        ),
      ],
      recommendations: [
        PriceRecommendation(
          itemId: '10',
          itemName: 'Keramik Dinding',
          currentPrice: 220000,
          recommendedPrice: 190000,
          savingPercentage: 13.6,
          reason: 'Alternatif dengan motif serupa dari distributor.',
          supplier: 'Keramik Indah',
        ),
      ],
      costCuttingRecs: [
        CostCuttingRecommendation(
          title: 'Kurangi Jumlah Kabinet Atas',
          description: 'Gunakan rak terbuka untuk menghemat',
          potentialSaving: 2400000,
          priority: 'high',
          category: 'Kayu',
          suggestions: ['Rak kayu solid', 'Rak besi minimalis'],
        ),
      ],
      costBreakdown: CostBreakdown(
        essentialCost: 12950000,
        optionalCost: 0,
        laborCost: 5000000,
        discountAmount: 200000,
        tax: 897500,
        adminFee: 100000,
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  // Data untuk tampilan card (tetap sederhana)
  final List<_ProjectCardData> cardData = const [
    _ProjectCardData(
      title: 'Scandinavian Room',
      location: 'Jakarta, ID',
      budget: 'Rp 15.500.000',
      status: 'IN PROGRESS',
      imagePath: 'assets/images/background3.png',
      isInProgress: true,
      projectIndex: 0,
    ),
    _ProjectCardData(
      title: 'Futuristic Office',
      location: null,
      budget: 'Rp 18.500.000',
      status: 'DRAFTING',
      imagePath: 'assets/images/background4.png',
      isInProgress: false,
      draftInfo: '12 item',
      projectIndex: 1,
    ),
    _ProjectCardData(
      title: 'Matte Kitchen',
      location: null,
      budget: 'Rp 18.800.000',
      status: null,
      imagePath: 'assets/images/background2.png',
      isInProgress: false,
      updatedInfo: 'Updated 2h ago',
      projectIndex: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PORTFOLIO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coconutGreen,
                  letterSpacing: 1.8,
                  fontFamily: 'PPNeueMontrealMedium',
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.coconutGreen,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Projects',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.metallicBlack,
                          fontFamily: 'PPEditorialNew',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Managing 3 active renovations with real-time\nbudget tracking.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.zenGray,
                  height: 1.5,
                  fontFamily: 'PPNeueMontrealMedium',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...cardData.map((data) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: _ProjectCard(
                data: data,
                project: _dummyProjects[data.projectIndex],
              ),
            )),
      ],
    );
  }
}

class _ProjectCardData {
  final String title;
  final String? location;
  final String budget;
  final String? status;
  final String imagePath;
  final bool isInProgress;
  final String? draftInfo;
  final String? updatedInfo;
  final int projectIndex;

  const _ProjectCardData({
    required this.title,
    required this.location,
    required this.budget,
    required this.status,
    required this.imagePath,
    required this.isInProgress,
    this.draftInfo,
    this.updatedInfo,
    required this.projectIndex,
  });
}

class _ProjectCard extends StatelessWidget {
  final _ProjectCardData data;
  final RenovationProject project;

  const _ProjectCard({required this.data, required this.project});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProjectDetailScreen(project: project),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 160,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                data.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.thatchGreen,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.55),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data.budget,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.metallicBlack,
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (data.status != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: data.isInProgress
                                    ? AppColors.coconutGreen
                                    : AppColors.zenGray.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                data.status!,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          Text(
                            data.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'PPEditorialNew',
                            ),
                          ),
                          if (data.location != null)
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 12, color: Colors.white70),
                                const SizedBox(width: 3),
                                Text(
                                  data.location!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          if (data.draftInfo != null)
                            Row(
                              children: [
                                const Icon(Icons.layers_outlined,
                                    size: 12, color: Colors.white70),
                                const SizedBox(width: 3),
                                Text(
                                  data.draftInfo!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          if (data.updatedInfo != null)
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded,
                                    size: 12, color: Colors.white70),
                                const SizedBox(width: 3),
                                Text(
                                  data.updatedInfo!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    if (data.isInProgress)
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward_rounded,
                            size: 18, color: AppColors.metallicBlack),
                      ),
                  ],
                ),
              ),
              if (data.isInProgress)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'TOTAL BUDGET',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: AppColors.zenGray,
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              data.budget,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.metallicBlack,
                                fontFamily: 'PPEditorialNew',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Budget Insight Card ──────────────────────────────────────────────────────
class _BudgetInsightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.metallicBlack.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.techWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.coconutGreen,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.techWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.techWhite,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.zenGray.withOpacity(0.4),
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Budget Insight',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.metallicBlack,
                fontFamily: 'PPEditorialNew',
              ),
            ),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.zenGray,
                  height: 1.5,
                  fontFamily: 'PPNeueMontrealMedium',
                ),
                children: [
                  const TextSpan(text: 'You saved '),
                  TextSpan(
                    text: '15%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.coconutGreen,
                    ),
                  ),
                  const TextSpan(
                      text:
                          ' on materials this month through smart rendering selections.'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFEEEEEE)),
            const SizedBox(height: 14),
            Text(
              'TOTAL PORTFOLIO VALUATION',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.zenGray,
                letterSpacing: 1.2,
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Rp 52.800.000',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.coconutGreen,
                fontFamily: 'PPEditorialNew',
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.metallicBlack,
                      side: const BorderSide(
                          color: Color(0xFFDDDDDD), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Export Report',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ManagePaymentScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.coconutGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Manage Payments',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.metallicBlack.withOpacity(0.08),
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
                            : AppColors.zenGray,
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
                              : AppColors.zenGray,
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

// ─── Data Models ─────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}