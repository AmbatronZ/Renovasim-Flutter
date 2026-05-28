import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'cs_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  // Track which FAQ is expanded
  int? _expandedFaq;

  final List<_FaqItem> _faqs = const [
    _FaqItem(
      question: 'Apakah hasil estimasi 100% akurat?',
      answer:
          'Tidak. Ini estimasi, bukan ramalan Tuhan. Gunakan sebagai acuan awal sebelum berkonsultasi dengan profesional.',
    ),
    _FaqItem(
      question: 'Apakah bisa digunakan untuk proyek besar?',
      answer:
          'Bisa, tapi tetap perlu validasi dari profesional (arsitek/kontraktor) sebelum mengambil keputusan final.',
    ),
    _FaqItem(
      question: 'Kenapa hasil tiap input berbeda?',
      answer:
          'Karena spesifikasi material dan ukuran mempengaruhi perhitungan. Semakin akurat data yang dimasukkan, semakin relevan hasilnya.',
    ),
    _FaqItem(
      question: 'Apakah visualisasi 3D bisa dijadikan desain akhir?',
      answer:
          'Tidak. Itu hanya gambaran kasar untuk membantu Anda membayangkan bentuk rumah. Untuk desain final, tetap gunakan jasa arsitek.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: Stack(
        children: [
          // ─── Green header background ───────────────────────────
          Container(height: 200, color: AppColors.thatchGreen),

          SafeArea(
            child: Column(
              children: [
                // ─── AppBar ──────────────────────────────────────
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
                        'Help & Support',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // ─── Header Card ─────────────────────────
                        _ContentCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.coconutGreen
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.help_outline_rounded,
                                      color: AppColors.coconutGreen,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pusat Bantuan',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.metallicBlack,
                                            fontFamily: 'PPEditorialNew',
                                          ),
                                        ),
                                        Text(
                                          'RenovaSim Help & Support',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.zenGray,
                                            fontFamily: 'PPNeueMontrealMedium',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Divider(color: Color(0xFFF0F0F0)),
                              const SizedBox(height: 14),
                              _BodyText(
                                'Selamat datang di RenovaSim, platform estimasi bahan bangunan dan visualisasi rumah berbasis 3D. Fitur utama kami dirancang untuk membantu Anda merencanakan pembangunan rumah dengan lebih akurat, efisien, dan terstruktur.\n\nKalau masih bingung pakainya, ya berarti wajar. Makanya ada bagian ini.',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── Cara Menggunakan ────────────────────
                        _ContentCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionTitle(
                                  '📱  Cara Menggunakan Aplikasi'),
                              const SizedBox(height: 16),
                              _SubSection(
                                label: 'a. Memulai Perhitungan',
                                items: [
                                  'Masukkan data dasar seperti luas bangunan, jumlah lantai, dan jenis rumah',
                                  'Pilih spesifikasi material sesuai kebutuhan',
                                  'Sistem akan otomatis menghitung estimasi bahan',
                                ],
                              ),
                              const SizedBox(height: 14),
                              _SubSection(
                                label: 'b. Melihat Hasil Estimasi',
                                items: [
                                  'Hasil berupa daftar bahan + perkiraan jumlah',
                                  'Estimasi biaya ditampilkan berdasarkan data yang tersedia',
                                  'Bisa dijadikan acuan awal, bukan angka mutlak',
                                ],
                              ),
                              const SizedBox(height: 14),
                              _SubSection(
                                label: 'c. Menggunakan Fitur 3D',
                                items: [
                                  'Aktifkan mode visualisasi',
                                  'Lihat bentuk rumah berdasarkan input',
                                  'Gunakan untuk gambaran awal, bukan desain final arsitek',
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── Fitur Utama ─────────────────────────
                        _ContentCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionTitle('⚡  Fitur Utama'),
                              const SizedBox(height: 16),
                              _FeatureItem(
                                icon: Icons.calculate_outlined,
                                title: 'Estimasi Bahan Bangunan',
                                desc:
                                    'Hitung kebutuhan material secara otomatis dan cepat',
                              ),
                              _FeatureItem(
                                icon: Icons.attach_money_rounded,
                                title: 'Perkiraan Biaya',
                                desc:
                                    'Memberikan gambaran total biaya pembangunan',
                              ),
                              _FeatureItem(
                                icon: Icons.view_in_ar_outlined,
                                title: 'Visualisasi 3D',
                                desc:
                                    'Menampilkan model rumah sederhana berdasarkan input',
                              ),
                              _FeatureItem(
                                icon: Icons.devices_rounded,
                                title: 'Multi Platform',
                                desc:
                                    'Bisa diakses melalui aplikasi dan website',
                                isLast: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── FAQ ─────────────────────────────────
                        _ContentCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionTitle('❓  FAQ'),
                              const SizedBox(height: 4),
                              Text(
                                'Pertanyaan yang Sering Ditanyakan',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.zenGray,
                                  fontFamily: 'PPNeueMontrealMedium',
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...List.generate(_faqs.length, (i) {
                                final isExpanded = _expandedFaq == i;
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        _expandedFaq =
                                            isExpanded ? null : i;
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: isExpanded
                                              ? AppColors.coconutGreen
                                                  .withOpacity(0.06)
                                              : AppColors.techWhite,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: isExpanded
                                                ? AppColors.coconutGreen
                                                    .withOpacity(0.3)
                                                : const Color(0xFFEEEEEE),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    _faqs[i].question,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: isExpanded
                                                          ? AppColors
                                                              .coconutGreen
                                                          : AppColors
                                                              .metallicBlack,
                                                      fontFamily:
                                                          'PPNeueMontrealMedium',
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  isExpanded
                                                      ? Icons
                                                          .keyboard_arrow_up_rounded
                                                      : Icons
                                                          .keyboard_arrow_down_rounded,
                                                  color: isExpanded
                                                      ? AppColors.coconutGreen
                                                      : AppColors.zenGray,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                            if (isExpanded) ...[
                                              const SizedBox(height: 10),
                                              const Divider(
                                                  color: Color(0xFFEEEEEE),
                                                  height: 1),
                                              const SizedBox(height: 10),
                                              Text(
                                                _faqs[i].answer,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.zenGray,
                                                  height: 1.6,
                                                  fontFamily:
                                                      'PPNeueMontrealMedium',
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (i < _faqs.length - 1)
                                      const SizedBox(height: 8),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── Tips ────────────────────────────────
                        _ContentCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionTitle('💡  Tips Penggunaan'),
                              const SizedBox(height: 14),
                              _TipsItem(
                                  'Masukkan data seakurat mungkin biar hasil gak ngawur'),
                              _TipsItem(
                                  'Bandingkan beberapa skenario sebelum ambil keputusan'),
                              _TipsItem(
                                  'Jangan 100% bergantung sama aplikasi, tetap pakai logika',
                                  isLast: true),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── Troubleshooting ─────────────────────
                        _ContentCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionTitle('🔧  Troubleshooting'),
                              const SizedBox(height: 16),
                              _SubSection(
                                label: 'Aplikasi tidak berjalan dengan baik',
                                items: [
                                  'Pastikan koneksi internet stabil',
                                  'Restart aplikasi',
                                  'Update ke versi terbaru',
                                ],
                              ),
                              const SizedBox(height: 14),
                              _SubSection(
                                label: 'Data tidak muncul',
                                items: [
                                  'Cek kembali input',
                                  'Pastikan semua field sudah diisi',
                                ],
                              ),
                              const SizedBox(height: 14),
                              _SubSection(
                                label: 'Visualisasi 3D tidak tampil',
                                items: [
                                  'Periksa perangkat apakah mendukung',
                                  'Coba reload fitur',
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── Kontak ──────────────────────────────
                        _ContentCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionTitle('📞  Kontak Dukungan'),
                              const SizedBox(height: 4),
                              Text(
                                'Jika mengalami kendala atau memiliki pertanyaan lebih lanjut, silakan hubungi kami melalui:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.zenGray,
                                  height: 1.5,
                                  fontFamily: 'PPNeueMontrealMedium',
                                ),
                              ),
                              const SizedBox(height: 14),
                              _ContactItem(
                                  icon: Icons.email_outlined,
                                  text: 'support@renovasim.com'),
                              _ContactItem(
                                  icon: Icons.language_rounded,
                                  text: 'www.renovasim.com'),
                              _ContactItem(
                                  icon: Icons.access_time_rounded,
                                  text: '09.00 – 17.00 WIB',
                                  isLast: true),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── Saran & Masukan ─────────────────────
                        _ContentCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionTitle('📝  Saran & Masukan'),
                              const SizedBox(height: 12),
                              _BodyText(
                                'Kami terbuka terhadap kritik dan saran. Kalau ada ide atau nemu bug, jangan disimpen sendiri kayak rahasia hidup lo, kontak saja email kami.',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ─── CS Button ───────────────────────────
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.85,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    child: const CsScreen(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              decoration: BoxDecoration(
                                color: AppColors.coconutGreen,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.coconutGreen
                                        .withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.headset_mic_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Chat dengan CS Kami',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontFamily: 'PPNeueMontrealMedium',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20), // ← jarak antara CS dan footer

                        // ─── Footer ─────────────────────────────
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              width: double.infinity, // ← tambah ini
                              child: Text(
                                '© 2025 RenovaSim. All rights reserved.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary(context),
                                  fontFamily: 'PPNeueMontrealMedium',
                                ),
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
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor(context),
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
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary(context),
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
        color: AppColors.textSecondary(context),
        height: 1.7,
        fontFamily: 'PPNeueMontrealMedium',
      ),
    );
  }
}

class _SubSection extends StatelessWidget {
  final String label;
  final List<String> items;

  const _SubSection({required this.label, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.metallicBlack,
            fontFamily: 'PPNeueMontrealMedium',
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 5, right: 10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.coconutGreen,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.zenGray,
                        height: 1.5,
                        fontFamily: 'PPNeueMontrealMedium',
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final bool isLast;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.desc,
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
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.coconutGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.coconutGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.metallicBlack,
                    fontFamily: 'PPNeueMontrealMedium',
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.zenGray,
                    height: 1.5,
                    fontFamily: 'PPNeueMontrealMedium',
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

class _TipsItem extends StatelessWidget {
  final String text;
  final bool isLast;
  const _TipsItem(this.text, {this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline_rounded,
              size: 16, color: AppColors.coconutGreen),
          const SizedBox(width: 10),
          Expanded(
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
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLast;

  const _ContactItem({
    required this.icon,
    required this.text,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.thatchGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.thatchGreen),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.metallicBlack,
              fontFamily: 'PPNeueMontrealMedium',
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data Model ───────────────────────────────────────────────────────────────
class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
}