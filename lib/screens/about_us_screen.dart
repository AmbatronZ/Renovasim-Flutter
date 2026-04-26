import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_screen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.techWhite,
      body: Stack(
        children: [
          // ─── Green header background ─────────────────────────
          Container(height: 200, color: AppColors.thatchGreen),

          SafeArea(
            child: Column(
              children: [
                // ─── AppBar ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'PPEditorialNew',
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // ─── Logo Card ──────────────────────────
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 28, horizontal: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.metallicBlack.withOpacity(0.07),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Logo
                              SvgPicture.asset(
                                'assets/images/renovasim_logo.svg',
                                height: 40,
                                placeholderBuilder: (_) => Text(
                                  'RenovaSim',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.metallicBlack,
                                    fontFamily: 'PPEditorialNew',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.coconutGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Platform Perencanaan Renovasi Digital',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.coconutGreen,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'PPNeueMontrealMedium',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ─── About Section ──────────────────────
                        _ContentCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionTitle('Tentang RenovaSim'),
                              const SizedBox(height: 12),
                              _BodyText(
                                'RenovaSim adalah aplikasi dan platform berbasis web yang dirancang untuk membantu pengguna dalam merencanakan pembangunan rumah secara lebih efisien dan terukur. Kami menyediakan solusi estimasi kebutuhan bahan bangunan yang akurat, sehingga pengguna dapat mengontrol biaya dan mengurangi risiko kesalahan perhitungan.',
                              ),
                              const SizedBox(height: 12),
                              _BodyText(
                                'Dengan menggabungkan teknologi perhitungan digital dan visualisasi 3D interaktif, RenovaSim memungkinkan pengguna tidak hanya menghitung kebutuhan material, tetapi juga melihat gambaran awal dari rumah impian mereka secara realistis. Pendekatan ini membantu dalam pengambilan keputusan yang lebih tepat sebelum proses pembangunan dimulai.',
                              ),
                              const SizedBox(height: 12),
                              _BodyText(
                                'RenovaSim dikembangkan untuk menjawab kebutuhan masyarakat modern yang menginginkan perencanaan pembangunan yang praktis, cepat, dan transparan. Baik untuk individu, kontraktor, maupun pengembang, platform ini hadir sebagai alat bantu yang andal dalam setiap tahap perencanaan.',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── Visi ───────────────────────────────
                        _ContentCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.coconutGreen
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: AppColors.coconutGreen,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  _SectionTitle('Visi'),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.techWhite,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.coconutGreen.withOpacity(0.2),
                                  ),
                                ),
                                child: _BodyText(
                                  'Menjadi platform digital terdepan dalam perencanaan pembangunan rumah berbasis teknologi dan visualisasi interaktif.',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── Misi ───────────────────────────────
                        _ContentCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.thatchGreen
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.flag_outlined,
                                      color: AppColors.thatchGreen,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  _SectionTitle('Misi'),
                                ],
                              ),
                              const SizedBox(height: 14),
                              _MisiItem(
                                icon: Icons.calculate_outlined,
                                text:
                                    'Menyediakan perhitungan bahan bangunan yang akurat dan mudah digunakan',
                              ),
                              _MisiItem(
                                icon: Icons.view_in_ar_outlined,
                                text:
                                    'Mengintegrasikan teknologi visualisasi 3D untuk pengalaman perencanaan yang lebih nyata',
                              ),
                              _MisiItem(
                                icon: Icons.savings_outlined,
                                text:
                                    'Membantu pengguna menghemat waktu, biaya, dan tenaga dalam proses pembangunan',
                              ),
                              _MisiItem(
                                icon: Icons.verified_outlined,
                                text:
                                    'Meningkatkan efisiensi dan transparansi dalam perencanaan konstruksi',
                                isLast: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── Footer ─────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '© 2025 RenovaSim. All rights reserved.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.zenGray,
                              fontFamily: 'PPNeueMontrealMedium',
                            ),
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
        ],
      ),
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _ContentCard extends StatelessWidget {
  final Widget child;
  const _ContentCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.metallicBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.metallicBlack,
        fontFamily: 'PPEditorialNew',
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;
  const _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: AppColors.zenGray,
        height: 1.7,
        fontFamily: 'PPNeueMontrealMedium',
      ),
    );
  }
}

class _MisiItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLast;

  const _MisiItem({
    required this.icon,
    required this.text,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.coconutGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.coconutGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.metallicBlack,
                  height: 1.5,
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