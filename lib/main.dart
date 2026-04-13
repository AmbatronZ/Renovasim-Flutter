import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const RenovaSimApp());
}

class RenovaSimApp extends StatelessWidget {
  const RenovaSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RenovaSim',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8BA023),
          primary: const Color(0xFF8BA023),
        ),
        fontFamily: 'PPNeueMontrealMedium',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}