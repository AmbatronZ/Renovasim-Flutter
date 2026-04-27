import 'package:flutter/material.dart';
import 'home_screen.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.techWhite,
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
                        'Terms & Conditions',
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
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.metallicBlack.withOpacity(0.07),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.thatchGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.gavel_rounded,
                                  color: AppColors.thatchGreen,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Syarat & Ketentuan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.metallicBlack,
                                        fontFamily: 'PPEditorialNew',
                                      ),
                                    ),
                                    Text(
                                      'Terakhir diperbarui: 2025',
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
                        ),

                        const SizedBox(height: 16),

                        // ─── Full Content Card ────────────────────
                        Container(
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
                          child: Text(
                            '1. Pendahuluan\n\n'
                            'Selamat datang di RenovaSim. Dengan mengakses dan menggunakan aplikasi serta website ini, Anda dianggap telah membaca, memahami, dan menyetujui seluruh syarat dan ketentuan yang berlaku.\n\n'
                            'Jika Anda tidak menyetujui salah satu bagian dari ketentuan ini, disarankan untuk tidak menggunakan layanan RenovaSim.\n\n'
                            '2. Deskripsi Layanan\n\n'
                            'RenovaSim menyediakan layanan estimasi kebutuhan bahan bangunan dan visualisasi rumah berbasis 3D sebagai alat bantu perencanaan.\n\n'
                            'Semua hasil yang diberikan bersifat estimasi dan tidak dapat dijadikan sebagai acuan final dalam proses konstruksi.\n\n'
                            '3. Batasan Tanggung Jawab\n\n'
                            'RenovaSim tidak menjamin keakuratan absolut dari hasil estimasi. Pengguna bertanggung jawab penuh atas keputusan yang diambil berdasarkan hasil dari aplikasi. RenovaSim tidak bertanggung jawab atas kerugian yang timbul akibat penggunaan layanan.\n\n'
                            'Kalau lo salah hitung terus bangunan ambles, itu bukan urusan aplikasi. Itu keputusan lo sendiri.\n\n'
                            '4. Penggunaan Layanan\n\n'
                            'Pengguna setuju untuk menggunakan layanan sesuai dengan hukum yang berlaku, tidak menyalahgunakan sistem termasuk hacking atau eksploitasi, serta tidak menggunakan data dari aplikasi untuk tujuan ilegal.\n\n'
                            '5. Hak Kekayaan Intelektual\n\n'
                            'Seluruh konten, fitur, desain, dan sistem dalam RenovaSim merupakan milik resmi pengembang dan dilindungi oleh hukum yang berlaku. Dilarang menyalin, mendistribusikan, atau memodifikasi tanpa izin tertulis.\n\n'
                            '6. Data Pengguna dan Privasi\n\n'
                            'RenovaSim dapat mengumpulkan data pengguna untuk meningkatkan layanan. Kami berkomitmen untuk menjaga keamanan data dan tidak membagikannya kepada pihak ketiga tanpa izin, kecuali diwajibkan oleh hukum.\n\n'
                            '7. Perubahan Layanan\n\n'
                            'RenovaSim berhak untuk mengubah atau menghentikan layanan kapan saja, serta memperbarui fitur tanpa pemberitahuan terlebih dahulu. Karena ya, dunia IT itu dinamis. Bukan batu.\n\n'
                            '8. Pembatasan Akses\n\n'
                            'Kami berhak menangguhkan atau menghentikan akses pengguna jika ditemukan pelanggaran terhadap ketentuan yang berlaku.\n\n'
                            '9. Hukum yang Berlaku\n\n'
                            'Ketentuan ini diatur dan ditafsirkan berdasarkan hukum yang berlaku di Indonesia.\n\n'
                            '10. Kontak\n\n'
                            'Jika terdapat pertanyaan terkait Terms & Conditions, silakan hubungi kami melalui:\n\n'
                            'Email: support@renovasim.com\n'
                            'Website: www.renovasim.com',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.zenGray,
                              height: 1.8,
                              fontFamily: 'PPNeueMontrealMedium',
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ─── Footer ──────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
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