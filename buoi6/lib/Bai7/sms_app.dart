import 'package:flutter/material.dart';

import 'screens/sms_analyzer_screen.dart';

class SmsApp extends StatefulWidget {
  const SmsApp({super.key});

  @override
  State<SmsApp> createState() => _SmsAppState();
}

class _SmsAppState extends State<SmsApp> {
  bool _isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Analyzer',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: SmsAnalyzerScreen(
        isDarkTheme: _isDarkTheme,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
