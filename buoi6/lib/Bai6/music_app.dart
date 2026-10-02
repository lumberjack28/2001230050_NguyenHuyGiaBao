import 'package:flutter/material.dart';

import 'screens/music_player_screen.dart';

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  // Biến cờ chuyển đổi Style giao diện Dark / Light
  bool _isDarkTheme = true;

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color brandPrimary = Color(
      0xFFC2185B,
    ); // Hồng tím neon chuẩn theo mẫu

    return MaterialApp(
      title: 'Music Player UI',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      // Giao diện Sáng (Light Theme)
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAF7F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandPrimary,
          brightness: Brightness.light,
          primary: brandPrimary,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1E1B1E)),
          bodyMedium: TextStyle(color: Color(0xFF49454F)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E1B1E)),
        useMaterial3: true,
      ),
      // Giao diện Tối (Dark Theme)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF131017),
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandPrimary,
          brightness: Brightness.dark,
          primary: brandPrimary,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        useMaterial3: true,
      ),
      home: MusicPlayerScreen(
        isDarkTheme: _isDarkTheme,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
