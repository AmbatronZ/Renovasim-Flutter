import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/user_session_provider.dart';
import '../../core/providers/project_provider.dart';
import '../../data/models/project_model.dart';
import '3D_screen.dart';
import 'rai_estimasi_screen.dart';

// Helper function to format compact local Indonesian Rupiah format
String _formatRupiahCompact(double amount) {
  if (amount >= 1000000000) {
    return 'Rp ${(amount / 1000000000).toStringAsFixed(1)}M';
  } else if (amount >= 1000000) {
    return 'Rp ${(amount / 1000000).toStringAsFixed(1)}Jt';
  } else {
    String str = amount.toInt().toString();
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count == 3 && i > 0) {
        result = '.' + result;
        count = 0;
      }
    }
    return 'Rp $result';
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  int _selectedNav = 2; // Start with Dashboard selected

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.folder_copy_rounded, label: 'Projects'),
    _NavItem(icon: Icons.view_in_ar_rounded, label: '3D Design'),
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
  ];

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    final userSession = context.read<UserSessionProvider>();
    final userId = userSession.userId;

    if (userId != null) {
      try {
        await context.read<ProjectProvider>().loadProjects(userId);
      } catch (_) {}
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator(color: AppColors.coconutGreen)),
      );
    }

    return Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          color: AppColors.coconutGreen,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: _buildMainContent(),
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
    final userSession = context.watch<UserSessionProvider>();
    final user = userSession.currentUser;
    final name = user?.firstName ?? user?.name ?? 'User';
    final role = user?.role ?? 'PROJECT OWNER';

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
                      text: name,
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
          // User Action badge
          Column(
            children: [
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
                  role.toUpperCase().replaceAll('_', '\n'),
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
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final userSession = context.read<UserSessionProvider>();
                  final user = userSession.currentUser;
                  if (user != null) {
                    final String urlString = 'http://localhost:8080/login?email=${Uri.encodeComponent(user.email)}&auto=true';
                    launchUrl(Uri.parse(urlString), mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground(context),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.dividerColor(context)),
                  ),
                  child: Icon(Icons.open_in_new_rounded, size: 16, color: AppColors.textSecondary(context)),
                ),
              ),
            ],
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
    final projectProvider = context.watch<ProjectProvider>();
    final projects = projectProvider.projects;
    final totalProjects = projects.length;

    double totalCost = 0;
    for (var p in projects) {
      totalCost += p.totalCost;
    }

    final totalPaid = totalCost * 0.74;

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
            value: '$totalProjects',
            subtitle: 'Active user projects',
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
                  value: _formatRupiahCompact(totalCost),
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
                  value: _formatRupiahCompact(totalPaid),
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
              'Get a personalized cost estimate, plan your\nproject and track payments in one place.',
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
  const _RecentEstimates();

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectProvider>().projects;
    final recent = projects.take(5).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
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
            child: recent.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long_outlined,
                              size: 36,
                              color: AppColors.textSecondary(context).withOpacity(0.4)),
                          const SizedBox(height: 10),
                          Text(
                            'Belum ada proyek estimasi.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary(context),
                              fontFamily: 'PPNeueMontrealMedium',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: List.generate(recent.length, (i) {
                      return Column(
                        children: [
                          _ProjectRow(parentContext: context, project: recent[i]),
                          if (i < recent.length - 1)
                            Divider(
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                              color: AppColors.dividerColor(context),
                            ),
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

class _ProjectRow extends StatelessWidget {
  final BuildContext parentContext;
  final ProjectModel project;
  const _ProjectRow({required this.parentContext, required this.project});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed': return const Color(0xFF4CAF50);
      case 'estimated': return AppColors.coconutGreen;
      default: return const Color(0xFF5B8DEF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = project.name;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';
    final statusColor = _statusColor(project.status);

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.coconutGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    initial,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary(parentContext),
                              fontFamily: 'PPNeueMontrealMedium',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            project.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                              fontFamily: 'PPNeueMontrealMedium',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${project.roomType.toUpperCase()} · ${project.areaSize.toStringAsFixed(0)} m²',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary(parentContext),
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 46),
              Expanded(
                child: Row(
                  children: [
                    _InfoLabel(
                      context: parentContext,
                      label: 'TOTAL ESTIMATE',
                      value: _formatRupiahCompact(project.totalCost),
                      isMain: true,
                    ),
                    const SizedBox(width: 16),
                    _InfoLabel(
                      context: parentContext,
                      label: 'LUAS AREA',
                      value: '${project.areaSize.toStringAsFixed(0)} m²',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoLabel extends StatelessWidget {
  final BuildContext context;
  final String label;
  final String value;
  final bool isMain;

  const _InfoLabel({
    required this.context,
    required this.label,
    required this.value,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: AppColors.textSecondary(context),
            letterSpacing: 0.5,
            fontFamily: 'PPNeueMontrealMedium',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isMain ? 14 : 12,
            fontWeight: isMain ? FontWeight.w800 : FontWeight.w700,
            color: isMain ? AppColors.coconutGreen : AppColors.textPrimary(context),
            fontFamily: isMain ? 'PPEditorialNew' : 'PPNeueMontrealMedium',
          ),
        ),
      ],
    );
  }
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
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
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
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
              ),
            );
          }),
        ),
      ),
    );
  }
}