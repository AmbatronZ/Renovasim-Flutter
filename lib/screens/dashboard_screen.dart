import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'home_screen.dart';
import '3D_screen.dart';
import 'rai_estimasi_screen.dart';
import 'rai_hasil_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedNav = 2; // Start with Dashboard selected

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.folder_copy_rounded, label: 'Projects'),
    _NavItem(icon: Icons.view_in_ar_rounded, label: '3D Design'),
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
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
              // ─── Header ──────────────────────────────────────
              _DashboardHeader(),
              const SizedBox(height: 20),

              // ─── Stats Row ───────────────────────────────────
              _StatsSection(),
              const SizedBox(height: 20),

              // ─── RAI Banner ──────────────────────────────────
              _RaiBanner(),
              const SizedBox(height: 20),

              // ─── Recent Estimates ────────────────────────────
              _RecentEstimates(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(
        items: _navItems,
        selectedIndex: _selectedNav,
        onTap: (i) {
          if (i == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const T3DScreen()),
            );
          } else if (i == 2) {
            // Already on Dashboard screen
          }
        },
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome back, ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary(context),
                        fontFamily: 'PPEditorialNew',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(
                      text: 'Rusdi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary(context),
                        fontFamily: 'PPEditorialNew',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Here's what's happening across your\nrenovation projects today.",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary(context),
                  height: 1.5,
                  fontFamily: 'PPNeueMontrealMedium',
                ),
              ),
            ],
          ),
          // Project Owner badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.coconutGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.coconutGreen.withOpacity(0.3),
              ),
            ),
            child: Text(
              'PROJECT\nOWNER',
              textAlign: TextAlign.center,
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
    );
  }
}

// ─── Stats Section ────────────────────────────────────────────────────────────

class _StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Top stat — Total Projects (full width)
          _StatCard(
            parentContext: context,
            icon: Icons.folder_copy_outlined,
            iconColor: const Color(0xFF5B8DEF),
            label: 'TOTAL PROJECTS',
            value: '3',
            subtitle: '+1 this month',
            fullWidth: true,
          ),
          const SizedBox(height: 12),
          // Bottom two stats side by side
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  parentContext: context,
                  icon: Icons.attach_money_rounded,
                  iconColor: const Color(0xFF4CAF50),
                  label: 'TOTAL PROJECT COST',
                  value: 'Rp 92,3M',
                  subtitle: 'Across all projects',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  parentContext: context,
                  icon: Icons.payment_rounded,
                  iconColor: const Color(0xFF5B8DEF),
                  label: 'TOTAL PAID',
                  value: 'Rp 68,5M',
                  subtitle: '74% of total',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final BuildContext parentContext;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;
  final bool fullWidth;

  const _StatCard({
    required this.parentContext,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(parentContext),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor(parentContext),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: fullWidth
          ? Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary(parentContext),
                        letterSpacing: 0.5,
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary(parentContext),
                        fontFamily: 'PPEditorialNew',
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.coconutGreen,
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    color: AppColors.textSecondary(parentContext),
                    letterSpacing: 0.5,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary(parentContext),
                    fontFamily: 'PPEditorialNew',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary(parentContext),
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
              ],
            ),
    );
  }
}

// ─── RAI Banner ───────────────────────────────────────────────────────────────

class _RaiBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Powered by RAI label
            Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 14,
                  color: AppColors.coconutGreen,
                ),
                const SizedBox(width: 6),
                Text(
                  'POWERED BY RAI',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coconutGreen,
                    letterSpacing: 1.2,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Plan & Estimate ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                      fontFamily: 'PPEditorialNew',
                    ),
                  ),
                  TextSpan(
                    text: 'with RAI',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textPrimary(context),
                      fontFamily: 'PPEditorialNew',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Get a personalized cost estimate, plan your\\nproject and track payments in one place.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary(context),
                height: 1.5,
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RaiEstimasiScreen(
                          projectName: null,
                          location: null,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.coconutGreen,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_rounded,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Create your first project',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'PPNeueMontrealMedium',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Takes less than\n30 seconds',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary(context),
                    height: 1.4,
                    fontFamily: 'PPNeueMontrealMedium',
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

// ─── Recent Estimates ─────────────────────────────────────────────────────────

class _RecentEstimates extends StatelessWidget {
  final List<_EstimateItem> estimates = const [
    _EstimateItem(
      initial: 'R',
      name: 'Rumah Pak Budi',
      modified: 'Modified 2 hours ago',
      status: 'IN PROGRESS',
      statusColor: Color(0xFFE8A020),
      material: 'Rp 12,4M',
      labor: 'Rp 8,2M',
    ),
    _EstimateItem(
      initial: 'K',
      name: 'Kitchen Expansion',
      modified: 'Modified 1 day ago',
      status: 'COMPLETED',
      statusColor: Color(0xFF4CAF50),
      material: 'Rp 45,0M',
      labor: 'Rp 18,5M',
    ),
    _EstimateItem(
      initial: 'G',
      name: 'Garden Decking',
      modified: 'Modified 3 days ago',
      status: 'DRAFT',
      statusColor: Color(0xFF9E9E9E),
      material: 'Rp 5,2M',
      labor: 'Rp 3,0M',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Recent Estimates',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                      fontFamily: 'PPEditorialNew',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'A snapshot of your latest renovation budgets',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary(context),
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View all →',
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
          const SizedBox(height: 14),

          // Estimate list
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground(context),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor(context),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: List.generate(estimates.length, (i) {
                return Column(
                  children: [
                    _EstimateRow(parentContext: context, item: estimates[i]),
                    if (i < estimates.length - 1)
                      Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: AppColors.dividerColor(context)),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _EstimateRow extends StatelessWidget {
  final BuildContext parentContext;
  final _EstimateItem item;
  const _EstimateRow({required this.parentContext, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Status + View button
          Row(
            children: [
              // Initial circle
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.coconutGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    item.initial,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coconutGreen,
                      fontFamily: 'PPEditorialNew',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(parentContext),
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                    Text(
                      item.modified,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary(parentContext),
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: item.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: item.statusColor.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: item.statusColor,
                    letterSpacing: 0.5,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Material + Labor + View button
          Row(
            children: [
              const SizedBox(width: 46),
              Expanded(
                child: Row(
                  children: [
                    _CostLabel(context: parentContext, label: 'MATERIAL', value: item.material),
                    const SizedBox(width: 16),
                    _CostLabel(context: parentContext, label: 'LABOR', value: item.labor),
                  ],
                ),
              ),
              // View button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    parentContext,
                    MaterialPageRoute(
                      builder: (_) => RaiHasilScreen(
                        projectName: item.name,
                        location: 'Surabaya',
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground(parentContext),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.dividerColor(parentContext)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.visibility_outlined,
                          size: 12, color: AppColors.textSecondary(parentContext)),
                      const SizedBox(width: 4),
                      Text(
                        'View',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary(parentContext),
                          fontFamily: 'PPNeueMontrealMedium',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CostLabel extends StatelessWidget {
  final BuildContext context;
  final String label;
  final String value;
  const _CostLabel({required this.context, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: AppColors.textSecondary(context),
            letterSpacing: 0.5,
            fontFamily: 'PPNeueMontrealMedium',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
            fontFamily: 'PPEditorialNew',
          ),
        ),
      ],
    );
  }
}

// ─── Data Models ──────────────────────────────────────────────────────────────

class _EstimateItem {
  final String initial;
  final String name;
  final String modified;
  final String status;
  final Color statusColor;
  final String material;
  final String labor;

  const _EstimateItem({
    required this.initial,
    required this.name,
    required this.modified,
    required this.status,
    required this.statusColor,
    required this.material,
    required this.labor,
  });
}

// ─── Nav Item Model ───────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final List<_NavItem> items;
  final int selectedIndex;
  final Function(int) onTap;

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
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
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
    );
  }
}