import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/pricing_provider.dart';
import '../../data/models/pricing_plan_model.dart';
import 'package:intl/intl.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  bool _isAnnual = false;
  int? _selectedPlanId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PricingProvider>().loadPlans();
    });
  }

  void _selectPlan(PricingPlanModel plan) {
    setState(() => _selectedPlanId = plan.id);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(
        planName: plan.name,
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
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.metallicBlack, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            Expanded(
              child: Consumer<PricingProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null && provider.plans.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Gagal memuat paket: ${provider.error}'),
                          TextButton(
                            onPressed: () => provider.loadPlans(),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // ─── Title ───────────────────────────────────
                        const Text(
                          'Plans & Pricing',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppColors.metallicBlack,
                            fontFamily: 'PPEditorialNew',
                          ),
                        ),
                        const SizedBox(height: 12),

                        const Text(
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

                        // ─── Dynamic Plans ────────────────────────────
                        ...provider.plans.map((plan) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _PricingCard(
                              plan: plan,
                              isAnnual: _isAnnual,
                              isSelected: _selectedPlanId == plan.id,
                              onSelect: () => _selectPlan(plan),
                            ),
                          );
                        }).toList(),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Pricing Card (Dynamic) ───────────────────────────────────────────────────

class _PricingCard extends StatelessWidget {
  final PricingPlanModel plan;
  final bool isAnnual;
  final bool isSelected;
  final VoidCallback onSelect;

  const _PricingCard({
    required this.plan,
    required this.isAnnual,
    required this.isSelected,
    required this.onSelect,
  });

  String _formatCurrency(double amount) {
    if (amount == 0) return 'Free';
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final price = isAnnual ? plan.priceAnnual : plan.priceMonthly;
    final isPopular = plan.isPopular;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPopular ? const Color(0xFFFFC928) : (isSelected ? AppColors.coconutGreen : const Color(0xFFE8E8E8)),
          width: isSelected || isPopular ? 2.5 : 1,
        ),
        boxShadow: isPopular 
          ? [
              BoxShadow(
                color: const Color(0xFFFFC928).withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ]
          : [
              BoxShadow(
                color: AppColors.metallicBlack.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: Column(
        children: [
          // Badge if any
          if (plan.badge != null || isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: isPopular ? const Color(0xFFFFC928) : AppColors.coconutGreen,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Text(
                (plan.badge ?? (isPopular ? 'MOST POPULAR PLAN' : '')).toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: isPopular ? Colors.black.withOpacity(0.75) : Colors.white,
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
                  plan.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.metallicBlack,
                    fontFamily: 'PPEditorialNew',
                  ),
                ),
                if (plan.description != null)
                  Text(
                    plan.description!,
                    style: const TextStyle(
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
                        text: _formatCurrency(price),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.metallicBlack,
                          fontFamily: 'PPEditorialNew',
                        ),
                      ),
                      if (price > 0)
                        const TextSpan(
                          text: ' /user',
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
                
                // Features
                ...plan.features.map((f) => _FeatureItem(
                  text: f.text, 
                  isHighlight: f.isHighlight
                )),
                
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
                      isSelected ? '✓ Plan Selected' : (price == 0 ? 'Try for free' : 'Select plan'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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