import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  bool _isAnnual = false;
  String? _selectedPlan;

  void _selectPlan(String planName) {
    setState(() => _selectedPlan = planName);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(
        planName: planName,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.techWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Back button ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.metallicBlack, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ─── Title ───────────────────────────────────
                    Text(
                      'Plans & Pricing',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.metallicBlack,
                        fontFamily: 'PPEditorialNew',
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Pilih paket yang sesuai dengan kebutuhan Anda. '
                      'Semua paket mencakup fitur-fitur penting untuk memulai, '
                      'dengan opsi untuk meningkatkan skala seiring pertumbuhan '
                      'bisnis Anda. Tidak ada biaya tersembunyi dan fleksibilitas '
                      'untuk mengubah paket kapan saja.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.zenGray,
                        height: 1.6,
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ─── Monthly / Annual Toggle ──────────────────
                    _BillingToggle(
                      isAnnual: _isAnnual,
                      onChanged: (v) => setState(() => _isAnnual = v),
                    ),
                    const SizedBox(height: 28),

                    // ─── Professional Plan ────────────────────────
                    _ProfessionalCard(
                      isAnnual: _isAnnual,
                      isSelected: _selectedPlan == 'Professional',
                      onSelect: () => _selectPlan('Professional'),
                    ),
                    const SizedBox(height: 16),

                    // ─── Starter Plan ─────────────────────────────
                    _StarterCard(
                      isSelected: _selectedPlan == 'Starter',
                      onSelect: () => _selectPlan('Starter'),
                    ),
                    const SizedBox(height: 16),

                    // ─── Organization Plan ────────────────────────
                    _OrganizationCard(
                      isAnnual: _isAnnual,
                      isSelected: _selectedPlan == 'Organization',
                      onSelect: () => _selectPlan('Organization'),
                    ),
                    const SizedBox(height: 40),
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

// ─── Billing Toggle ───────────────────────────────────────────────────────────

class _BillingToggle extends StatelessWidget {
  final bool isAnnual;
  final ValueChanged<bool> onChanged;

  const _BillingToggle({required this.isAnnual, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ToggleOption(
                label: 'Monthly',
                isSelected: !isAnnual,
                onTap: () => onChanged(false),
              ),
              _ToggleOption(
                label: 'Annual',
                isSelected: isAnnual,
                onTap: () => onChanged(true),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '-15% off on annual payments',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.coconutGreen,
            fontWeight: FontWeight.w600,
            fontFamily: 'PPNeueMontrealMedium',
          ),
        ),
      ],
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.metallicBlack : AppColors.zenGray,
            fontFamily: 'PPNeueMontrealMedium',
          ),
        ),
      ),
    );
  }
}

// ─── Professional Card (White + Yellow Stroke) ────────────────────────────────

class _ProfessionalCard extends StatelessWidget {
  final bool isAnnual;
  final bool isSelected;
  final VoidCallback onSelect;

  const _ProfessionalCard({
    required this.isAnnual,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final price = isAnnual ? 'Rp.42.500' : 'Rp.50.000';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFC928),
          width: isSelected ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFC928).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Most Popular badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: const BoxDecoration(
              color: Color(0xFFFFC928),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Text(
              'MOST POPULAR PLAN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.black.withOpacity(0.75),
                letterSpacing: 1.2,
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Professional',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.metallicBlack,
                    fontFamily: 'PPEditorialNew',
                  ),
                ),
                Text(
                  'For freelancers and startups',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.zenGray,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                const SizedBox(height: 14),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: price,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.metallicBlack,
                          fontFamily: 'PPEditorialNew',
                        ),
                      ),
                      TextSpan(
                        text: ' /per user',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.zenGray,
                          fontFamily: 'PPNeueMontrealMedium',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _FeatureItem(text: 'All starter features +', isHighlight: true),
                _FeatureItem(text: 'Up to 5 user accounts'),
                _FeatureItem(text: 'Team collaboration tools'),
                _FeatureItem(text: 'Custom dashboards'),
                _FeatureItem(text: 'Multiple data export formats'),
                _FeatureItem(text: 'Up to 100 project room'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.metallicBlack,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      isSelected ? '✓ Plan Selected' : 'Select plan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'or contact sales',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.zenGray,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.zenGray,
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Starter Card ─────────────────────────────────────────────────────────────

class _StarterCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onSelect;

  const _StarterCard({required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.coconutGreen : const Color(0xFFE8E8E8),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.metallicBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Starter',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.metallicBlack,
              fontFamily: 'PPEditorialNew',
            ),
          ),
          Text(
            'Ideal for small projects',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.zenGray,
              fontFamily: 'PPNeueMontrealMedium',
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Free',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.metallicBlack,
              fontFamily: 'PPEditorialNew',
            ),
          ),
          const SizedBox(height: 16),
          _FeatureItem(text: 'Unlimited personal files'),
          _FeatureItem(text: 'Email support'),
          _FeatureItem(text: 'CSV data export'),
          _FeatureItem(text: 'Basic analytics dashboard'),
          _FeatureItem(text: '1,000 API calls per month'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.metallicBlack,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                isSelected ? '✓ Plan Selected' : 'Try for free',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'PPNeueMontrealMedium',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Organization Card ────────────────────────────────────────────────────────

class _OrganizationCard extends StatelessWidget {
  final bool isAnnual;
  final bool isSelected;
  final VoidCallback onSelect;

  const _OrganizationCard({
    required this.isAnnual,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final price = isAnnual ? '\Rp.220.000' : '\Rp.250.000';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.coconutGreen : const Color(0xFFE8E8E8),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.metallicBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Organization',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.metallicBlack,
              fontFamily: 'PPEditorialNew',
            ),
          ),
          Text(
            'For fast-growing businesses',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.zenGray,
              fontFamily: 'PPNeueMontrealMedium',
            ),
          ),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.metallicBlack,
                    fontFamily: 'PPEditorialNew',
                  ),
                ),
                TextSpan(
                  text: ' /per user',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.zenGray,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _FeatureItem(text: 'All professional features +', isHighlight: true),
          _FeatureItem(text: 'Enterprise security suite'),
          _FeatureItem(text: 'Single Sign-On (SSO)'),
          _FeatureItem(text: 'Custom contract terms'),
          _FeatureItem(text: 'Dedicated phone support'),
          _FeatureItem(text: 'Custom integration support'),
          _FeatureItem(text: 'Compliance tools'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.metallicBlack,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                isSelected ? '✓ Plan Selected' : 'Select plan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'PPNeueMontrealMedium',
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'or contact sales',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.zenGray,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.zenGray,
                  fontFamily: 'PPNeueMontrealMedium',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Feature Item ─────────────────────────────────────────────────────────────

class _FeatureItem extends StatelessWidget {
  final String text;
  final bool isHighlight;

  const _FeatureItem({required this.text, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isHighlight
                ? Icons.check_circle_rounded
                : Icons.check_circle_outline_rounded,
            size: 16,
            color: isHighlight ? AppColors.coconutGreen : AppColors.zenGray,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isHighlight ? FontWeight.w700 : FontWeight.w400,
                color: isHighlight
                    ? AppColors.metallicBlack
                    : AppColors.zenGray,
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Success Dialog ───────────────────────────────────────────────────────────

class _SuccessDialog extends StatelessWidget {
  final String planName;
  final VoidCallback onClose;

  const _SuccessDialog({required this.planName, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.metallicBlack.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.coconutGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.coconutGreen,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Paket Berhasil Dipilih!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.metallicBlack,
                fontFamily: 'PPEditorialNew',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Anda telah memilih paket $planName.\nPembayaran akan segera diproses.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.zenGray,
                height: 1.5,
                fontFamily: 'PPNeueMontrealMedium',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.coconutGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Lanjutkan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}