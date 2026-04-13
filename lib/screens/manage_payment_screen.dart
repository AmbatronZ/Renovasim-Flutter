// lib/screens/manage_payment_screen.dart
import 'package:flutter/material.dart';
import '../models/renovation_models.dart';

class ManagePaymentScreen extends StatelessWidget {
  const ManagePaymentScreen({super.key});

  // --- Data Dummy (Contoh) ---
  static final List<RenovationItem> _dummyItems = [
    RenovationItem(
      id: '1',
      name: 'Cat Tembok Interior',
      description: 'Cat berkualitas tinggi untuk dinding dalam',
      category: MaterialCategory.paint,
      quantity: 5,
      unit: 'galon',
      unitPrice: 250000,
      isEssential: true,
    ),
    RenovationItem(
      id: '2',
      name: 'Keramik Lantai 60x60',
      description: 'Keramik motif kayu',
      category: MaterialCategory.tile,
      quantity: 30,
      unit: 'm²',
      unitPrice: 185000,
      isEssential: true,
    ),
    RenovationItem(
      id: '3',
      name: 'Pintu Kayu Solid',
      description: 'Pintu utama kayu jati',
      category: MaterialCategory.wood,
      quantity: 2,
      unit: 'unit',
      unitPrice: 2500000,
      isEssential: true,
    ),
    RenovationItem(
      id: '4',
      name: 'Lampu LED Panel',
      description: 'Lampu hemat energi',
      category: MaterialCategory.electric,
      quantity: 8,
      unit: 'pcs',
      unitPrice: 175000,
      isEssential: false,
    ),
    RenovationItem(
      id: '5',
      name: 'Tenaga Tukang',
      description: 'Upah harian',
      category: MaterialCategory.labor,
      quantity: 20,
      unit: 'hari',
      unitPrice: 200000,
      isEssential: true,
    ),
  ];

  static final CostBreakdown _dummyBreakdown = CostBreakdown(
    essentialCost: 8875000,  // dari item essential
    optionalCost: 1400000,   // dari item non-essential
    laborCost: 4000000,      // dari item labor
    discountAmount: 500000,
    tax: 713750,             // 5% contoh
    adminFee: 100000,
  );

  static final List<PriceRecommendation> _dummyPriceRecs = [
    PriceRecommendation(
      itemId: '2',
      itemName: 'Keramik Lantai 60x60',
      currentPrice: 185000,
      recommendedPrice: 165000,
      savingPercentage: 10.8,
      reason: 'Supplier B menawarkan harga lebih rendah untuk kualitas setara.',
      supplier: 'Toko Bangunan Jaya',
    ),
    PriceRecommendation(
      itemId: '4',
      itemName: 'Lampu LED Panel',
      currentPrice: 175000,
      recommendedPrice: 150000,
      savingPercentage: 14.3,
      reason: 'Diskon pembelian grosir di Supplier C.',
      supplier: 'Cahaya Elektrik',
    ),
  ];

  static final List<CostCuttingRecommendation> _dummyCuttingRecs = [
    CostCuttingRecommendation(
      title: 'Ganti Cat dengan Merek Lokal',
      description: 'Kualitas setara, hemat hingga 15%',
      potentialSaving: 750000,
      priority: 'high',
      category: 'Material',
      suggestions: ['Merek A', 'Merek B'],
    ),
    CostCuttingRecommendation(
      title: 'Kurangi Jumlah Lampu Hias',
      description: 'Lampu fungsional sudah cukup untuk pencahayaan',
      potentialSaving: 350000,
      priority: 'medium',
      category: 'Listrik',
      suggestions: ['Gunakan lampu downlight standar'],
    ),
  ];

  static final RenovationProject _dummyProject = RenovationProject(
    id: 'proj-001',
    projectName: 'Renovasi Ruang Tamu & Dapur',
    description: 'Perbaikan lantai, pengecatan, dan instalasi listrik',
    items: _dummyItems,
    recommendations: _dummyPriceRecs,
    costCuttingRecs: _dummyCuttingRecs,
    costBreakdown: _dummyBreakdown,
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    updatedAt: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    final project = _dummyProject;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Manage Payments'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export report')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan Proyek
            _ProjectSummaryCard(project: project),
            const SizedBox(height: 16),

            // Daftar Material
            _SectionTitle(title: 'Daftar Material & Jasa'),
            const SizedBox(height: 8),
            _MaterialList(items: project.items),
            const SizedBox(height: 16),

            // Rincian Biaya
            _SectionTitle(title: 'Rincian Biaya'),
            const SizedBox(height: 8),
            _CostBreakdownCard(breakdown: project.costBreakdown),
            const SizedBox(height: 16),

            // Rekomendasi Harga AI
            if (project.recommendations.isNotEmpty) ...[
              _SectionTitle(title: '💡 Rekomendasi Harga dari AI'),
              const SizedBox(height: 8),
              ...project.recommendations.map((rec) => _PriceRecCard(rec: rec)),
              const SizedBox(height: 16),
            ],

            // Rekomendasi Penghematan
            if (project.costCuttingRecs.isNotEmpty) ...[
              _SectionTitle(title: '💰 Potensi Penghematan'),
              const SizedBox(height: 8),
              ...project.costCuttingRecs.map((rec) => _CuttingRecCard(rec: rec)),
              const SizedBox(height: 24),
            ],

            // Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Export PDF
                    },
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Export PDF'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Melanjutkan ke pembayaran...'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.payment_outlined),
                    label: const Text('Bayar Sekarang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8BA023),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// --- Widget Pembantu ---

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2C2C2B),
        ),
      ),
    );
  }
}

class _ProjectSummaryCard extends StatelessWidget {
  final RenovationProject project;
  const _ProjectSummaryCard({required this.project});

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
            project.projectName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2C2C2B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            project.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
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
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF8BA023),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Biaya Essential',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                _formatCurrency(project.essentialCost),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MaterialList extends StatelessWidget {
  final List<RenovationItem> items;
  const _MaterialList({required this.items});

  String _formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <MaterialCategory, List<RenovationItem>>{};
    for (var item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Text(
                  entry.key.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B411E),
                  ),
                ),
              ),
              ...entry.value.map((item) => _MaterialItemTile(item: item)),
              if (entry.key != grouped.keys.last)
                const Divider(height: 1, thickness: 0.5),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MaterialItemTile extends StatelessWidget {
  final RenovationItem item;
  const _MaterialItemTile({required this.item});

  String _formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (!item.isEssential)
            const Icon(Icons.star_border, size: 16, color: Colors.orange)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${item.quantity} ${item.unit} x ${_formatCurrency(item.unitPrice)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatCurrency(item.subtotal),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _CostBreakdownCard extends StatelessWidget {
  final CostBreakdown breakdown;
  const _CostBreakdownCard({required this.breakdown});

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
      ),
      child: Column(
        children: [
          _BreakdownRow(
            label: 'Biaya Essential',
            value: _formatCurrency(breakdown.essentialCost),
          ),
          _BreakdownRow(
            label: 'Biaya Optional',
            value: _formatCurrency(breakdown.optionalCost),
          ),
          _BreakdownRow(
            label: 'Biaya Tenaga Kerja',
            value: _formatCurrency(breakdown.laborCost),
          ),
          const Divider(height: 24),
          _BreakdownRow(
            label: 'Subtotal',
            value: _formatCurrency(breakdown.subtotal),
            bold: true,
          ),
          _BreakdownRow(
            label: 'Diskon (${breakdown.discountPercentage.toStringAsFixed(1)}%)',
            value: '- ${_formatCurrency(breakdown.discountAmount)}',
            valueColor: Colors.green,
          ),
          _BreakdownRow(
            label: 'Pajak (5%)',
            value: _formatCurrency(breakdown.tax),
          ),
          _BreakdownRow(
            label: 'Biaya Admin',
            value: _formatCurrency(breakdown.adminFee),
          ),
          const Divider(height: 24),
          _BreakdownRow(
            label: 'Total',
            value: _formatCurrency(breakdown.total),
            bold: true,
            fontSize: 18,
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final double fontSize;
  final Color? valueColor;

  const _BreakdownRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.fontSize = 14,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRecCard extends StatelessWidget {
  final PriceRecommendation rec;
  const _PriceRecCard({required this.rec});

  String _formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_offer, size: 18, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rec.itemName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Hemat ${rec.savingPercentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Harga saat ini: ${_formatCurrency(rec.currentPrice)}',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              Text(
                _formatCurrency(rec.recommendedPrice),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Supplier: ${rec.supplier}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            rec.reason,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _CuttingRecCard extends StatelessWidget {
  final CostCuttingRecommendation rec;
  const _CuttingRecCard({required this.rec});

  String _formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _priorityColor(rec.priority).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  rec.priority.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _priorityColor(rec.priority),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rec.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                _formatCurrency(rec.potentialSaving),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8BA023),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            rec.description,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: rec.suggestions
                .map((s) => Chip(
                      label: Text(s, style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.grey.shade100,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}