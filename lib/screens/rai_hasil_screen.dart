import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class RaiHasilScreen extends StatelessWidget {
  final String projectName;
  final String location;

  const RaiHasilScreen({
    super.key,
    required this.projectName,
    required this.location,
  });

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
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
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
              // Subtitle/Project Name
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
                  'MODE STANDARD – ${projectName.toUpperCase()}',
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
                        children: const [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: Color(0xFFF39C12),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Asuransi yang mengira Ngini atau biaya asmai canggih nyin. Estimator ini nilai meskipun pleaser cpt discon dan span istilng',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF856404),
                                fontFamily: 'PPNeueMontrealMedium',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Danger Alert
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
                        children: const [
                          Icon(
                            Icons.warning_rounded,
                            size: 20,
                            color: Color(0xFFDC3545),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Budget halo ≥ 10,000,000 tetanggamu tidak ada untuk cek ini. Estimasi masimal  Rp 33,3/7.000',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF721C24),
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
                      const Text(
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
                          valueColor: const AlwaysStoppedAnimation<Color>(
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
                    _SummaryItem(label: 'Lokasi', value: location.isNotEmpty ? location : 'Surabaya'),
                    const _SummaryItem(label: 'Jenis Bangunan', value: 'Renovasi'),
                    const _SummaryItem(
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
                      onTap: () => Navigator.pop(context),
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
                        onPressed: () {
                          // Simple action to show confirmation
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Project disimpan!')),
                          );
                        },
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
                          children: const [
                            Icon(Icons.save_rounded, size: 18),
                            SizedBox(width: 8),
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
                const Icon(
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
