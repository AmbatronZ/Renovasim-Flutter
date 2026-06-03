import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/user_session_provider.dart';
import '../../core/laravel_api_config.dart';
import '../../data/models/room_model.dart';
import '../../data/repositories/room_repository.dart';
import 'dashboard_screen.dart';

class T3DScreen extends StatefulWidget {
  const T3DScreen({super.key});

  @override
  State<T3DScreen> createState() => _3DScreenState();
}

class _3DScreenState extends State<T3DScreen> {
  int _selectedNav = 1;
  List<RoomModel> _captures = [];
  bool _isLoading = true;
  String? _error;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.folder_copy_rounded, label: 'Projects'),
    _NavItem(icon: Icons.view_in_ar_rounded, label: '3D Design'),
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLaravelCaptures();
    });
  }

  Future<void> _loadLaravelCaptures() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final userSession = context.read<UserSessionProvider>();
    final userId = userSession.userId;

    if (userId == null) {
      setState(() {
        _isLoading = false;
        _error = 'User tidak terautentikasi. Silakan login kembali.';
      });
      return;
    }

    try {
      final rooms = await RoomRepository.getRoomsByUserId(userId);
      setState(() {
        _captures = rooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Gagal memuat capture dari Supabase. Pastikan koneksi aktif.';
      });
    }
  }

  Future<void> _openRoomEditor(int roomId) async {
    final String urlString = '${LaravelApiConfig.baseUrl}/room/$roomId/editor';
    final Uri url = Uri.parse(urlString);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        messenger.showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka editor room: $urlString')),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan membuka browser: $e')),
      );
    }
  }

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
                      'AI-generated structural 3D models and room layouts.',
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

              const SizedBox(height: 28),

              // ─── Recent Captures ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Recent Captures',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(context),
                          fontFamily: 'PPEditorialNew',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _loadLaravelCaptures,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh_rounded, size: 14, color: AppColors.coconutGreen),
                          const SizedBox(width: 4),
                          Text(
                            'Refresh',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.coconutGreen,
                              fontFamily: 'PPNeueMontrealMedium',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Loading / Error / Empty States & Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildMainContent(),
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
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (i == 1) {
            setState(() => _selectedNav = 1);
          } else if (i == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: AppColors.coconutGreen),
      );
    }

    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 36),
            const SizedBox(height: 10),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary(context),
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _loadLaravelCaptures,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coconutGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_captures.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.dividerColor(context)),
        ),
        child: Column(
          children: [
            Icon(Icons.view_in_ar_rounded, size: 48, color: AppColors.textSecondary(context).withOpacity(0.5)),
            const SizedBox(height: 14),
            Text(
              'Belum Ada Capture Ruangan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary(context),
                fontFamily: 'PPEditorialNew',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Gunakan dashboard web untuk memindai atau membuat visualisasi ruangan 3D baru.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary(context),
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemCount: _captures.length,
      itemBuilder: (_, i) => _CaptureRoomCard(
        room: _captures[i],
        onTap: () => _openRoomEditor(_captures[i].id),
      ),
    );
  }
}

// ─── Capture Room Card (Premium Architectural Design) ─────────────────────────

class _CaptureRoomCard extends StatelessWidget {
  final RoomModel room;
  final VoidCallback onTap;

  const _CaptureRoomCard({required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Check if thumbnail exists (Supabase URL or Base64)
    final bool isNetworkImage = room.imagePath != null && room.imagePath!.isNotEmpty && room.imagePath!.startsWith('http');
    final bool isBase64Image = room.imagePath != null && room.imagePath!.isNotEmpty && room.imagePath!.startsWith('data:image');
    
    ImageProvider? imageProvider;
    if (isNetworkImage) {
      imageProvider = NetworkImage(room.imagePath!);
    } else if (isBase64Image) {
      try {
        final base64Str = room.imagePath!.split(',').last;
        imageProvider = MemoryImage(base64Decode(base64Str));
      } catch (e) {
        print('Error decoding base64: $e');
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.cardBackground(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.dividerColor(context)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image or Placeholder
            if (imageProvider != null)
              Image(
                image: imageProvider,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(context),
              )
            else
              _buildPlaceholder(context),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // Room Name and Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name ?? 'Untitled Room',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'PPNeueMontrealMedium',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${(room.width * room.length).toStringAsFixed(1)}m²',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3D4E2C),
            const Color(0xFF232B18),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.room_preferences_outlined,
              size: 32,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                room.name ?? 'Untitled Room',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.3),
                  fontFamily: 'PPNeueMontrealMedium',
                ),
              ),
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