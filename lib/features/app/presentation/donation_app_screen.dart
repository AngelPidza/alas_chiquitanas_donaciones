import 'package:flutter/material.dart';
import '/features/auth/presentation/pages/auth_wrapper_screen.dart';

class DonationsApp extends StatelessWidget {
  const DonationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Donaciones',
      theme: ThemeData(
        primaryColor: Color(0xFF003566),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF003566),
          primary: Color(0xFF003566),
          secondary: Color(0xFFFFC300),
          tertiary: Color(0xFFFFD60A),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF000814),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFC300),
            foregroundColor: Color(0xFF000814),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF003566)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFFFC300), width: 2),
          ),
        ),
      ),
      home: AuthWrapper(),
    );
  }
}
