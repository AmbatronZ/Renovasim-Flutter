import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme_provider.dart';
import 'home_screen.dart';
import 'dashboard_screen.dart';
import 'ai_create_screen.dart';

class T3DScreen extends StatefulWidget {
  const T3DScreen({super.key});

  @override
  State<T3DScreen> createState() => _3DScreenState();
}

class _3DScreenState extends State<T3DScreen> {
  String _selectedStyle = 'Modern Scandinavian';
  int _selectedNav = 2;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.folder_copy_rounded, label: 'Projects'),
    _NavItem(icon: Icons.auto_awesome_rounded, label: 'AI Create'),
    _NavItem(icon: Icons.view_in_ar_rounded, label: '3D Design'),
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
  ];

  final List<String> _styles = [
    'Modern Scandinavian',
    'Industrial Loft',
    'Japandi',
    'Bohemian',
    'Minimalist',
  ];

  // Dummy recent captures
  final List<_CaptureItem> _captures = const [
    _CaptureItem(
      imagePath: 'assets/images/background3.png',
      label: null,
    ),
    _CaptureItem(
      imagePath: 'assets/images/background4.png',
      label: null,
    ),
    _CaptureItem(
      imagePath: 'assets/images/background5.png',
      label: 'NEW SCAN',
      isNewScan: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ─── Hero Title ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Transform ',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: AppColors.coconutGreen,
                              fontFamily: 'PPEditorialNew',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextSpan(
                            text: 'Space',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary(context),
                              fontFamily: 'PPEditorialNew',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Select a starting point for your AI-powered\nrenovation.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary(context),
                        height: 1.5,
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ─── Upload Blueprint Card ────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _UploadBlueprintCard(),
              ),

              const SizedBox(height: 14),

              // ─── Capture Space Card ───────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _CaptureSpaceCard(),
              ),

              const SizedBox(height: 24),

              // ─── Design Aesthetics ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Design Aesthetics',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context),
                        fontFamily: 'PPEditorialNew',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.coconutGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'STYLE ENGINE 4.0',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.coconutGreen,
                          letterSpacing: 0.8,
                          fontFamily: 'PPNeueMontrealMedium',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Style chips — horizontal scroll
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _styles.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final isSelected = _styles[i] == _selectedStyle;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedStyle = _styles[i]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.coconutGreen
                              : AppColors.cardBackground(context),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.coconutGreen
                                : AppColors.dividerColor(context),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.coconutGreen
                                        .withOpacity(0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : [],
                        ),
                        child: Text(
                          _styles[i],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary(context),
                            fontFamily: 'PPNeueMontrealMedium',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ─── Recent Captures ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Captures',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(context),
                        fontFamily: 'PPEditorialNew',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'View Library',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.coconutGreen,
                          fontFamily: 'PPNeueMontrealMedium',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Captures grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _captures.length,
                  itemBuilder: (_, i) => _CaptureCard(item: _captures[i]),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(
        items: _navItems,
        selectedIndex: _selectedNav,
        onTap: (i) {
          if (i == 0) {
            // Navigate back to Home/Projects
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (i == 1) {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AiCreateScreen()),
            );
            setState(() => _selectedNav = 1);
          } else if (i == 2) {
            // Navigate to 3D Design
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const T3DScreen()),
            );
          } else if (i == 3) {
            // Navigate to Dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          } else if (i == 3) {
            // Navigate to Dashboard
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

// ─── Upload Blueprint Card ────────────────────────────────────────────────────

class _UploadBlueprintCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.dividerColor(context),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor(context),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.dividerColor(context)),
            ),
            child: Icon(
              Icons.folder_outlined,
              color: AppColors.textSecondary(context),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Blueprint',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                    fontFamily: 'PPEditorialNew',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Import technical floor plans (PDF, JPG, CAD) for hyper-accurate structural reconstruction.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary(context),
                    height: 1.5,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'START IMPORT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.coconutGreen,
                          letterSpacing: 0.5,
                          fontFamily: 'PPNeueMontrealMedium',
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: AppColors.coconutGreen,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Decorative triangle icon
          Opacity(
            opacity: 0.08,
            child: Icon(
              Icons.change_history_rounded,
              size: 48,
              color: AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Capture Space Card ───────────────────────────────────────────────────────

class _CaptureSpaceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.coconutGreen,
            AppColors.thatchGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.coconutGreen.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Camera icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Capture Space',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'PPEditorialNew',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Use your camera to scan the room in real-time. AI detects dimensions and fixtures automatically.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.5,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'OPEN CAMERA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.8,
                            fontFamily: 'PPNeueMontrealMedium',
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: 12,
                            color: AppColors.coconutGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Decorative illustration
          Opacity(
            opacity: 0.15,
            child: Icon(
              Icons.home_outlined,
              size: 72,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Capture Card ─────────────────────────────────────────────────────────────

class _CaptureCard extends StatelessWidget {
  final _CaptureItem item;
  const _CaptureCard({required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.isNewScan) {
      return GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.dividerColor(context),
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.coconutGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  color: AppColors.coconutGreen,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'NEW SCAN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary(context),
                  letterSpacing: 0.8,
                  fontFamily: 'PPNeueMontrealMedium',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            item.imagePath,
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
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data Model ───────────────────────────────────────────────────────────────

class _CaptureItem {
  final String imagePath;
  final String? label;
  final bool isNewScan;

  const _CaptureItem({
    required this.imagePath,
    this.label,
    this.isNewScan = false,
  });
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