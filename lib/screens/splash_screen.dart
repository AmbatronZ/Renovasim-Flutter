import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'welcome_screen.dart';
import 'error_screen.dart';
import 'home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _dotsController;
  late Animation<double> _logoFadeAnim;
  late Animation<double> _logoScaleAnim;
  late Animation<double> _dotsAnim;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();

    _logoFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _logoScaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _dotsAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_dotsController);

    _logoController.forward();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    // Simulate checking: network connection & auth token
    await Future.delayed(const Duration(seconds: 3));

    // Simulate a check — swap these booleans to test flows:
    const bool hasNetwork = true;
    const bool isLoggedIn = false;

    if (!mounted) return;

    if (!hasNetwork) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ErrorScreen(isNetworkError: true),
        ),
      );
    } else if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    } else {
      // TODO: Navigate to home/dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image (blurred house photo)
            Image.asset(
            'assets/images/background1.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.55),
            colorBlendMode: BlendMode.darken,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E3A5F), Color(0xFF0F172A)],
                ),
              ),
            ),
          ),

          // Center logo
          Center(
            child: FadeTransition(
              opacity: _logoFadeAnim,
              child: ScaleTransition(
                scale: _logoScaleAnim,
                child: const _RenovaSimLogo(light: true),
              ),
            ),
          ),

          // Bottom loading indicator
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _dotsAnim,
              builder: (_, __) => _PulsingDots(progress: _dotsAnim.value),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDots extends StatelessWidget {
  final double progress;
  const _PulsingDots({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final phase = (progress - i * 0.3) % 1.0;
        final opacity = (phase < 0.5 ? phase * 2 : (1.0 - phase) * 2)
            .clamp(0.3, 1.0);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(opacity),
          ),
        );
      }),
    );
  }
}

// ─── Shared Logo Widget ──────────────────────────────────────────────────────

class _RenovaSimLogo extends StatelessWidget {
  final bool light;
  const _RenovaSimLogo({this.light = false});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return SvgPicture.asset(
      isDark ? 'assets/images/renovasim_new.svg' : 'assets/images/renovasim_new2.svg',
      height: 40,
    );
  }
}