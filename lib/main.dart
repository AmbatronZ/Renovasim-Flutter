import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'core/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const RenovaSimApp(),
    ),
  );
}

class RenovaSimApp extends StatelessWidget {
  const RenovaSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // ← tambah ini

    return MaterialApp(
      title: 'RenovaSim',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode, // ← tambah ini
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8BA023),
          primary: const Color(0xFF8BA023),
        ),
        fontFamily: 'PPNeueMontrealMedium',
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith( // ← tambah ini
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8BA023),
          primary: const Color(0xFF8BA023),
          brightness: Brightness.dark,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'PPNeueMontrealMedium',
        ),
      ),
      home: const SplashScreen(),
    );
  }
}