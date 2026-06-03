import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../data/repositories/laravel_estimation_repository.dart';
import 'rai_hasil_screen.dart';

class RaiEstimasiScreen extends StatefulWidget {
  final String? projectName;
  final String? location;

  const RaiEstimasiScreen({
    super.key,
    required this.projectName,
    required this.location,
  });

  @override
  State<RaiEstimasiScreen> createState() => _RaiEstimasiScreenState();
}

class _RaiEstimasiScreenState extends State<RaiEstimasiScreen> {
  final _deskripsiCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  String? _selectedLokasi;
  bool _isLoading = false;
  int _charCount = 0;
  static const int _minChar = 10;

  final List<String> _lokasiOptions = [
    'Jakarta',
    'Surabaya',
    'Bandung',
    'Medan',
    'Makassar',
    'Semarang',
    'Bali',
    'Yogyakarta',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _selectedLokasi = widget.location;
    _deskripsiCtrl.addListener(() {
      setState(() => _charCount = _deskripsiCtrl.text.length);
    });
  }

  @override
  void dispose() {
    _deskripsiCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  Future<void> _analisa() async {
    if (_charCount < _minChar) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Deskripsi minimal $_minChar karakter'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final budgetText = _budgetCtrl.text.replaceAll('.', '').replaceAll(',', '');
      final budget = double.tryParse(budgetText);

      final result = await LaravelEstimationRepository.estimateAI(
        projectName: widget.projectName ?? 'Estimasi Baru',
        description: _deskripsiCtrl.text,
        location: _selectedLokasi ?? widget.location,
        budget: budget,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RaiHasilScreen(
            result: result,
            location: _selectedLokasi ?? widget.location ?? 'Surabaya',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal melakukan analisa: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.techWhite,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Step indicator ───────────────────────────────
            _StepIndicator(
              currentStep: 2,
              onBack: () => Navigator.pop(context),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    // Form card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.metallicBlack.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back link + AI badge
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Row(
                                  children: [
                                    const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        size: 12,
                                        color: AppColors.zenGray),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Pilih mode lain',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.zenGray,
                                        fontFamily: 'PPNeueMontrealMedium',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.coconutGreen
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.coconutGreen
                                        .withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  'AI ASSISTANT',
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
                          const SizedBox(height: 20),

                          // Icon
                          Center(
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.coconutGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: AppColors.coconutGreen,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          Center(
                            child: Text(
                              'Ceritakan Rencana Renovasimu',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.metallicBlack,
                                fontFamily: 'PPEditorialNew',
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Center(
                            child: Text(
                              'Tulis bebas — AI akan menganalisa dan menghitung estimasi biaya.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.zenGray,
                                fontFamily: 'PPNeueMontrealMedium',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Deskripsi
                          _FieldLabel(
                              'DESKRIPSIKAN RENCANA RENOVASI',
                              required: true),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.techWhite,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: TextField(
                              controller: _deskripsiCtrl,
                              maxLines: 6,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.metallicBlack),
                              decoration: InputDecoration(
                                hintText:
                                    'cth: Aku ingin merenovasi kamar tidur ukuran 4x4m. '
                                    'Ganti cat dinding, pasang vinyl floor, dan perbaiki '
                                    'plafon yang bocor. Material standar, lokasi Jakarta.',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.zenGray.withOpacity(0.55),
                                  fontFamily: 'PPNeueMontrealMedium',
                                  height: 1.5,
                                ),
                                contentPadding: const EdgeInsets.all(14),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Char counter
                          Row(
                            children: [
                              Text(
                                '$_charCount/$_minChar karakter minimum',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _charCount >= _minChar
                                      ? AppColors.coconutGreen
                                      : AppColors.zenGray,
                                  fontFamily: 'PPNeueMontrealMedium',
                                ),
                              ),
                              if (_charCount >= _minChar) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.check_rounded,
                                    size: 12,
                                    color: AppColors.coconutGreen),
                              ],
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Lokasi
                          _FieldLabel('LOKASI', optional: true),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.techWhite,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedLokasi,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 4),
                                border: InputBorder.none,
                              ),
                              hint: Text(
                                'Pilih kota',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.zenGray.withOpacity(0.6),
                                  fontFamily: 'PPNeueMontrealMedium',
                                ),
                              ),
                              items: _lokasiOptions
                                  .map((l) => DropdownMenuItem(
                                      value: l, child: Text(l)))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedLokasi = v),
                            ),
                          ),
                          if (widget.location != null) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 12, color: AppColors.zenGray),
                                const SizedBox(width: 4),
                                Text(
                                  'Lokasi diambil dari project: ${widget.location}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.zenGray,
                                    fontFamily: 'PPNeueMontrealMedium',
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 20),

                          // Budget
                          _FieldLabel('BUDGET RP', optional: true),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.techWhite,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 14),
                                  child: Text(
                                    'Rp',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.zenGray,
                                      fontFamily: 'PPNeueMontrealMedium',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _budgetCtrl,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.metallicBlack),
                                    decoration: InputDecoration(
                                      hintText: '10.000.000',
                                      hintStyle: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.zenGray
                                            .withOpacity(0.5),
                                        fontFamily: 'PPNeueMontrealMedium',
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 13),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Analisa button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _analisa,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.coconutGreen,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                            Icons.auto_awesome_rounded,
                                            size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Analisa dengan AI',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'PPEditorialNew',
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Semakin detail deskripsimu, semakin akurat estimasinya',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.zenGray,
                                fontFamily: 'PPNeueMontrealMedium',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step Indicator ───────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBack;

  const _StepIndicator({
    required this.currentStep,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: AppColors.metallicBlack),
            onPressed: onBack,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StepDot(
                  label: 'PILIH MODE',
                  step: 1,
                  isDone: true,
                  isActive: false,
                ),
                _StepLine(isActive: true),
                _StepDot(
                  label: 'ESTIMASI',
                  step: 2,
                  isDone: false,
                  isActive: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final String label;
  final int step;
  final bool isDone;
  final bool isActive;

  const _StepDot({
    required this.label,
    required this.step,
    required this.isDone,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone || isActive
                ? AppColors.coconutGreen
                : const Color(0xFFE0E0E0),
            border: Border.all(
              color: isDone || isActive
                  ? AppColors.coconutGreen
                  : const Color(0xFFE0E0E0),
              width: 2,
            ),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check_rounded,
                    color: Colors.white, size: 16)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : AppColors.zenGray,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: isDone || isActive
                ? AppColors.metallicBlack
                : AppColors.zenGray,
            letterSpacing: 0.5,
            fontFamily: 'PPNeueMontrealMedium',
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isActive;
  const _StepLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: isActive ? AppColors.coconutGreen : const Color(0xFFE0E0E0),
    );
  }
}

// ─── Field Label ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  final bool optional;

  const _FieldLabel(this.text, {this.required = false, this.optional = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.zenGray,
            letterSpacing: 0.8,
            fontFamily: 'PPNeueMontrealMedium',
          ),
        ),
        if (required)
          const Text(' *',
              style: TextStyle(color: Colors.red, fontSize: 12)),
        if (optional)
          Text(
            ' (OPSIONAL)',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.zenGray.withOpacity(0.6),
              fontFamily: 'PPNeueMontrealMedium',
            ),
          ),
      ],
    );
  }
}