import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'core/theme_provider.dart';
import 'core/providers/user_session_provider.dart';
import 'core/providers/project_provider.dart';
import 'core/providers/room_provider.dart';
import 'core/providers/material_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserSessionProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => MaterialProvider()),
      ],
      child: const RenovaSimApp(),
    ),
  );
}

class RenovaSimApp extends StatelessWidget {
  const RenovaSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'RenovaSim',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF8BA023),
              primary: const Color(0xFF8BA023),
              surface: const Color(0xFFF5F5F5),
              brightness: Brightness.light,
            ),
            fontFamily: 'PPNeueMontrealMedium',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF1E1E1E),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF8BA023),
              primary: const Color(0xFF8BA023),
              surface: const Color(0xFF1E1E1E),
              brightness: Brightness.dark,
            ),
            fontFamily: 'PPNeueMontrealMedium',
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}