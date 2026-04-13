// lib/screens/project_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/renovation_models.dart';
import 'manage_payment_screen.dart';
import 'room_3d_editor_screen.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailScreen extends StatelessWidget {
  final RenovationProject project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // App Bar dengan gambar 3D / foto ruangan
          _SliverAppBarWith3D(project: project),

          // Konten utama
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Proyek
                  _ProjectInfoCard(project: project),
                  const SizedBox(height: 20),

                  // Bagian Visual 3D (Placeholder)
                  _SectionTitle(
                    title: 'Visualisasi 3D Ruangan',
                    icon: Icons.view_in_ar_rounded,
                  ),
                  const SizedBox(height: 8),
                  _Room3DPreview(project: project),
                  const SizedBox(height: 20),

                  // Daftar Material yang Perlu Direnovasi
                  _SectionTitle(
                    title: 'Material Renovasi',
                    icon: Icons.format_list_bulleted_rounded,
                  ),
                  const SizedBox(height: 8),
                  _RenovationItemList(items: project.items),
                  const SizedBox(height: 20),

                  // Rekomendasi AI
                  _SectionTitle(
                    title: 'Rekomendasi AI',
                    icon: Icons.auto_awesome_rounded,
                    subtitle: 'Prioritas renovasi berdasarkan analisis',
                  ),
                  const SizedBox(height: 8),
                  _AIRecommendationSection(project: project),
                  const SizedBox(height: 20),

                  // Ringkasan Biaya Cepat
                  _CostSummaryCard(breakdown: project.costBreakdown),
                  const SizedBox(height: 24),

                  // Tombol Lanjut ke Pembayaran
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigasi ke halaman Manage Payment
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManagePaymentScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.payment_outlined),
                      label: const Text(
                        'Lanjut ke Pembayaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BA023),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Sliver App Bar dengan Gambar 3D / Ruangan ---
class _SliverAppBarWith3D extends StatelessWidget {
  final RenovationProject project;
  const _SliverAppBarWith3D({required this.project});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: const Color(0xFF2C2C2B),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.share_outlined, color: Colors.white, size: 20),
          ),
          onPressed: () {
            // TODO: Share project
          },
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.more_vert, color: Colors.white, size: 20),
          ),
          onPressed: () {
            // TODO: More options
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          project.projectName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3.0,
                color: Color.fromARGB(150, 0, 0, 0),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Placeholder gambar 3D / ruangan
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF3B411E),
                    const Color(0xFF2C2C2B).withOpacity(0.8),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.view_in_ar_rounded,
                      size: 64,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '3D Room Preview',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to interact',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Overlay gradasi agar teks terbaca
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Judul Bagian ---
class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? subtitle;

  const _SectionTitle({
    required this.title,
    this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: const Color(0xFF8BA023)),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C2C2B),
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }
}

// --- Kartu Informasi Proyek ---
class _ProjectInfoCard extends StatelessWidget {
  final RenovationProject project;
  const _ProjectInfoCard({required this.project});

  String _formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _InfoChip(
                icon: Icons.calendar_today_outlined,
                label: 'Dibuat: ${_formatDate(project.createdAt)}',
              ),
              const SizedBox(width: 12),
              _InfoChip(
                icon: Icons.update_rounded,
                label: 'Update: ${_formatDate(project.updatedAt)}',
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Estimasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatCurrency(project.totalCost),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF8BA023),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// --- Preview 3D Ruangan (Placeholder Interaktif) ---
class _Room3DPreview extends StatelessWidget {
  final RenovationProject project;
  const _Room3DPreview({required this.project});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
  // URL backend AI Room Builder
  final serverUrl = kIsWeb
      ? 'http://localhost:8000'
      : 'http://10.0.2.2:8000';

  final editorUrl = '$serverUrl/editor';

  if (kIsWeb) {
    // Web: buka di tab browser baru
    final uri = Uri.parse(editorUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // fallback: tampilkan pesan error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka editor 3D. Pastikan backend berjalan.'),
          ),
        );
      }
    }
  } else {
    // Mobile (Android/iOS): gunakan WebView
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Room3DWebViewScreen(
            serverUrl: serverUrl,
            initialSceneId: null,
          ),
        ),
      );
    }
  }
},
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Placeholder gambar 3D
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF3B411E).withOpacity(0.8),
                      const Color(0xFF1A1A1A).withOpacity(0.9),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_circle_outline_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Lihat Ruangan dalam 3D',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Geser untuk melihat sudut ruangan',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Overlay indikator "3D"
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.threed_rotation,
                          size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        '3D VIEW',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Daftar Item Renovasi ---
class _RenovationItemList extends StatelessWidget {
  final List<RenovationItem> items;
  const _RenovationItemList({required this.items});

  String _formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    // Kelompokkan berdasarkan kategori
    final grouped = <MaterialCategory, List<RenovationItem>>{};
    for (var item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Text(
                      entry.key.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3B411E),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${entry.value.length} item',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              ...entry.value.map((item) => _RenovationItemTile(item: item)),
              if (entry.key != grouped.keys.last)
                const Divider(height: 1, thickness: 0.5),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _RenovationItemTile extends StatelessWidget {
  final RenovationItem item;
  const _RenovationItemTile({required this.item});

  String _formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon status essential
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: item.isEssential
                  ? const Color(0xFF8BA023).withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              item.isEssential
                  ? Icons.priority_high_rounded
                  : Icons.star_border_rounded,
              size: 16,
              color: item.isEssential ? const Color(0xFF8BA023) : Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${item.quantity} ${item.unit}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'x ${_formatCurrency(item.unitPrice)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatCurrency(item.subtotal),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xFF2C2C2B),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Bagian Rekomendasi AI ---
class _AIRecommendationSection extends StatelessWidget {
  final RenovationProject project;
  const _AIRecommendationSection({required this.project});

  @override
  Widget build(BuildContext context) {
    // Gabungkan rekomendasi harga dan penghematan
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Rekomendasi Prioritas Utama (AI-generated insight)
          _PriorityInsightCard(project: project),

          // Rekomendasi Harga
          if (project.recommendations.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.savings_outlined,
                          size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'Rekomendasi Harga Lebih Baik',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...project.recommendations
                      .map((rec) => _CompactPriceRecCard(rec: rec)),
                ],
              ),
            ),
          ],

          // Rekomendasi Penghematan
          if (project.costCuttingRecs.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline,
                          size: 18, color: Colors.amber),
                      const SizedBox(width: 8),
                      const Text(
                        'Tips Penghematan Biaya',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...project.costCuttingRecs
                      .map((rec) => _CompactCuttingRecCard(rec: rec)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PriorityInsightCard extends StatelessWidget {
  final RenovationProject project;
  const _PriorityInsightCard({required this.project});

  @override
  Widget build(BuildContext context) {
    // Simulasi insight AI utama
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3B411E).withOpacity(0.05),
            const Color(0xFF8BA023).withOpacity(0.1),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF8BA023).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFF8BA023),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prioritas Renovasi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C2C2B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _generateAIPriorityText(project),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _PriorityTag(label: 'Essential', color: Colors.red),
                    const SizedBox(width: 8),
                    _PriorityTag(label: 'Hemat 15%', color: Colors.green),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _generateAIPriorityText(RenovationProject project) {
    // Analisis sederhana berdasarkan data
    final essentialItems = project.items.where((i) => i.isEssential).length;
    final totalItems = project.items.length;
    if (essentialItems > totalItems / 2) {
      return 'Fokus pada material essential terlebih dahulu. Pertimbangkan untuk menunda item optional demi menghemat anggaran.';
    } else {
      return 'Anda memiliki banyak item optional. Rekomendasi: kurangi atau ganti dengan alternatif lebih murah untuk menghemat biaya.';
    }
  }
}

class _PriorityTag extends StatelessWidget {
  final String label;
  final Color color;
  const _PriorityTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _CompactPriceRecCard extends StatelessWidget {
  final PriceRecommendation rec;
  const _CompactPriceRecCard({required this.rec});

  String _formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.itemName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  rec.supplier,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCurrency(rec.recommendedPrice),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
              Text(
                'Hemat ${rec.savingPercentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactCuttingRecCard extends StatelessWidget {
  final CostCuttingRecommendation rec;
  const _CompactCuttingRecCard({required this.rec});

  String _formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rec.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  rec.description,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF8BA023).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _formatCurrency(rec.potentialSaving),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF8BA023),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Ringkasan Biaya Cepat ---
class _CostSummaryCard extends StatelessWidget {
  final CostBreakdown breakdown;
  const _CostSummaryCard({required this.breakdown});

  String _formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal Material',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                _formatCurrency(
                    breakdown.essentialCost + breakdown.optionalCost),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tenaga Kerja',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                _formatCurrency(breakdown.laborCost),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Estimasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _formatCurrency(breakdown.total),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF8BA023),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}