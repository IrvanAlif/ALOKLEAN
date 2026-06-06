import 'package:flutter/material.dart';
import 'pages/auth/login_page.dart';

void main() {
  runApp(const AlokleanApp());
}

class AlokleanApp extends StatelessWidget {
  const AlokleanApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0B4FA8);
    const secondary = Color(0xFFFFD54F);
    const bg = Color(0xFFF5F8FD);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ALOKLEAN',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: secondary,
          surface: Colors.white,
          surfaceContainerHighest: bg,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          foregroundColor: primary,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: primary, width: 1.2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
