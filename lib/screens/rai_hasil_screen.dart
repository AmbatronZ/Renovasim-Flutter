import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/project_provider.dart';
import '../../core/providers/user_session_provider.dart';
import '../data/models/estimation_result_model.dart';
import '../data/repositories/laravel_estimation_repository.dart';
import 'package:intl/intl.dart';

class RaiHasilScreen extends StatefulWidget {
  final EstimationResultModel result;
  final String location;

  const RaiHasilScreen({
    super.key,
    required this.result,
    required this.location,
  });

  @override
  State<RaiHasilScreen> createState() => _RaiHasilScreenState();
}

class _RaiHasilScreenState extends State<RaiHasilScreen> {
  bool _isSaving = false;

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  Future<void> _saveToProject() async {
    final userSession = context.read<UserSessionProvider>();
    final projectProvider = context.read<ProjectProvider>();

    if (userSession.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Save estimation result to Supabase estimations table
      await LaravelEstimationRepository.saveToSupabase(
        userSession.userId!,
        widget.result,
      );

      // Create new project with full estimation data
      await projectProvider.createProject(
        userId: userSession.userId!,
        name: widget.result.projectName,
        roomType: widget.result.mode,
        areaSize: widget.result.breakdown.isNotEmpty
            ? widget.result.breakdown[0].area
            : 25.0,
        totalCost: widget.result.totalRange.min,
        status: 'estimated',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proyek berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Refresh and go back
      await projectProvider.loadProjects(userSession.userId!);
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      print('Save error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan proyek: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final location = widget.location;
    
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
                        size: 18,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        'HASIL ESTIMASI'.toUpperCase(),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary(context),
                          letterSpacing: 1.0,
                          fontFamily: 'PPNeueMontrealMedium',
                        ),
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
                  result.projectName,
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
                  'MODE ${result.mode.toUpperCase()} – ${result.projectName.toUpperCase()}',
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
              // Alert boxes (Warnings)
              if (result.warnings.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: result.warnings.map((warning) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
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
                              const Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: Color(0xFFF39C12),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  warning,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF856404),
                                    fontFamily: 'PPNeueMontrealMedium',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 12),
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
                        result.totalRange.display,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.coconutGreen,
                          fontFamily: 'PPEditorialNew',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatCurrency(result.totalRange.min)} – ${_formatCurrency(result.totalRange.max)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary(context),
                          fontFamily: 'PPNeueMontrealMedium',
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Confidence Level
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text(
                            'CONFIDENCE LEVEL',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary(context),
                              letterSpacing: 0.8,
                              fontFamily: 'PPNeueMontrealMedium',
                            ),
                          ),
                          Text(
                            result.confidence.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.coconutGreen,
                              fontFamily: 'PPNeueMontrealMedium',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: result.confidence.score / 100,
                          minHeight: 8,
                          backgroundColor: AppColors.dividerColor(context),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.coconutGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result.confidence.message,
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
              if (result.breakdown.isNotEmpty)
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
                      _BreakdownTable(breakdown: result.breakdown),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              // Assumptions
              if (result.assumptions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ASSUMPTIONS & CLARIFICATIONS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary(context),
                          letterSpacing: 1.2,
                          fontFamily: 'PPNeueMontrealMedium',
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...result.assumptions.map((a) => _SummaryItem(
                            label: a.field,
                            value: a.value,
                            subtitle: a.reason,
                            isWarning: a.needsClarification,
                          )),
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
                        onPressed: _isSaving ? null : _saveToProject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            children: [
                              _isSaving 
                                ? const SizedBox(
                                    width: 16, 
                                    height: 16, 
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                  )
                                : const Icon(Icons.save_rounded, size: 16),
                              Text(
                                _isSaving ? 'Menyimpan...' : 'Simpan ke Project',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'PPNeueMontrealMedium',
                                ),
                              ),
                            ],
                          ),
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
  final List<BreakdownItem> breakdown;

  const _BreakdownTable({required this.breakdown});

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(2.5),
      },
      border: TableBorder(
        horizontalInside: BorderSide(
          color: AppColors.dividerColor(context),
        ),
      ),
      children: breakdown.map((item) {
        return TableRow(
          children: [
            _TableCell(item.jobType),
            _TableCell('AREA ${item.area.toStringAsFixed(0)} m²',
                align: TextAlign.right),
            _TableCell(
                '${_formatCurrency(item.min)} – ${_formatCurrency(item.max)}',
                align: TextAlign.right),
          ],
        );
      }).toList(),
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Text(
        text,
        textAlign: align,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10,
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
  final String? subtitle;
  final bool isWarning;

  const _SummaryItem({
    required this.label,
    required this.value,
    this.subtitle,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isWarning ? Icons.info_outline_rounded : Icons.check_circle_rounded,
                size: 16,
                color: isWarning ? Colors.orange : AppColors.coconutGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 2),
              child: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary(context),
                  fontFamily: 'PPNeueMontrealMedium',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
