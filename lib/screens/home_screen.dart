import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'dashboard_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme_provider.dart';
import '../../core/providers/project_provider.dart';
import '../../core/providers/room_provider.dart';
import '../../core/providers/user_session_provider.dart';
import '../../data/models/project_model.dart';
import '../../data/models/room_model.dart';
import 'notification_screen.dart';
import '3D_screen.dart';
import 'plan_screen.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNav = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.folder_copy_rounded, label: 'Projects'),
    _NavItem(icon: Icons.view_in_ar_rounded, label: '3D Design'),
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(parentContext: context),
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
        onTap: (i) {
          if (i == 1) {
            // Navigate to 3D Design
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const T3DScreen()),
            );
          } else if (i == 2) {
            // Navigate to Dashboard
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          } else {
            setState(() => _selectedNav = i);
          }
        },
      ),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final BuildContext parentContext;
  const _TopBar({required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        children: [
          SvgPicture.asset(
            isDark ? 'assets/images/renovasim_new.svg' : 'assets/images/renovasim_new2.svg',
            height: 32,
          ),
          const Spacer(),
          _IconBtn(
            icon: Icons.notifications_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ),
              );
            },
          ),
          _IconBtn(
            icon: Icons.settings_outlined,
            onTap: () => Navigator.push(
              parentContext,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          _IconBtn(
            icon: Icons.person_outline_rounded,
            onTap: () => Navigator.push(
              parentContext,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 22, color: AppColors.textPrimary(context)),
        ),
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
        child: Container(
          height: 260,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/background1.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.thatchGreen, AppColors.metallicBlack],
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
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final userSession = context.read<UserSessionProvider>();
                        final user = userSession.currentUser;
                        if (user != null) {
                          final String urlString = 'http://localhost:8080/login?email=${Uri.encodeComponent(user.email)}&auto=true';
                          final Uri url = Uri.parse(urlString);
                          try {
                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Could not open web portal')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.coconutGreen,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.add_circle_outline_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Start New Project',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'PPNeueMontrealMedium',
                                ),
                                overflow: TextOverflow.ellipsis,
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

class _PortfolioSection extends StatefulWidget {
  const _PortfolioSection({Key? key}) : super(key: key);

  @override
  State<_PortfolioSection> createState() => _PortfolioSectionState();
}

class _PortfolioSectionState extends State<_PortfolioSection> {
  @override
  void initState() {
    super.initState();
    // Defer loading until after build phase completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProjects();
    });
  }

  Future<void> _loadProjects() async {
    final userSession = context.read<UserSessionProvider>();
    final projectProvider = context.read<ProjectProvider>();
    
    if (userSession.userId != null) {
      await projectProvider.loadProjects(userSession.userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, _) {
        // Show loading state
        if (projectProvider.isLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircularProgressIndicator(color: AppColors.coconutGreen),
                const SizedBox(height: 16),
                Text(
                  'Loading projects...',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary(context),
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
              ],
            ),
          );
        }

        // Show error state
        if (projectProvider.error != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Icon(
                  Icons.error_outline,
                  color: Colors.red[400],
                  size: 40,
                ),
                const SizedBox(height: 16),
                Text(
                  projectProvider.error ?? 'Error loading projects',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary(context),
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _loadProjects,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Show empty state
        if (projectProvider.projects.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Icon(
                  Icons.folder_open,
                  size: 50,
                  color: AppColors.textSecondary(context),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Projects Yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first renovation project to get started.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary(context),
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
              ],
            ),
          );
        }

        // Show projects
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
                      Text(
                        'Active Projects',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary(context),
                          fontFamily: 'PPEditorialNew',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Managing ${projectProvider.projects.length} ${projectProvider.projects.length == 1 ? 'project' : 'projects'} with real-time tracking.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary(context),
                      height: 1.5,
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: projectProvider.projects.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DashboardScreen(),
                      ),
                    );
                  },
                  child: _ProjectCard(data: projectProvider.projects[index]),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String tag, String title, int count, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tag,
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
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary(context),
                  fontFamily: 'PPEditorialNew',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Managing $count ${count == 1 ? 'project' : 'projects'} with real-time tracking.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary(context),
              height: 1.5,
              fontFamily: 'PPNeueMontrealMedium',
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectModel data;
  const _ProjectCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final status = data.status.toLowerCase();
    
    // Status color mapping
    Color statusBgColor;
    Color statusTextColor;
    String statusLabel = status.toUpperCase();

    if (status == 'completed') {
      statusBgColor = const Color(0xFFE8F5E9);
      statusTextColor = const Color(0xFF2E7D32);
    } else if (status == 'estimated' || status == 'active') {
      statusBgColor = AppColors.coconutGreen.withOpacity(0.15);
      statusTextColor = AppColors.coconutGreen;
      statusLabel = 'IN PROGRESS';
    } else {
      statusBgColor = Colors.white.withOpacity(0.2);
      statusTextColor = Colors.white;
      statusLabel = 'DRAFT';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 180,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.asset(
                data.imagePath ?? 'assets/images/background3.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3D4E2C), Color(0xFF232B18)],
                    ),
                  ),
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(8),
                            border: status == 'draft' 
                                ? Border.all(color: Colors.white.withOpacity(0.3)) 
                                : null,
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: statusTextColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Bottom Details
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontFamily: 'PPEditorialNew',
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _InfoTag(icon: Icons.door_sliding_outlined, label: data.roomType.replaceAll('_', ' ').toUpperCase()),
                                  const SizedBox(width: 12),
                                  _InfoTag(icon: Icons.square_foot_rounded, label: '${data.areaSize}m²'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.coconutGreen,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.coconutGreen.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ],
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

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 12),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.8),
            ),
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