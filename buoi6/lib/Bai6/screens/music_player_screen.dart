import 'package:flutter/material.dart';

import '../models/song_model.dart';
import 'playlist_screen.dart';

class MusicPlayerScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkTheme;

  const MusicPlayerScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkTheme,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>
    with SingleTickerProviderStateMixin {
  bool isPlaying = true;
  bool isFavorite = false;
  double currentProgress = 0.4;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.isDarkTheme
                ? [
                    const Color(0xFF1E0B24),
                    const Color(0xFF2E0832),
                    const Color(0xFF0F0814),
                  ]
                : [
                    const Color(0xFFFFE4E6),
                    const Color(0xFFFCE7F3),
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Thanh Top Bar: Đổi Theme + Tiêu đề ALBUM + Nút sang Playlist
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        widget.isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                        color: theme.iconTheme.color,
                      ),
                      tooltip: 'Đổi phong cách giao diện',
                      onPressed: widget.onToggleTheme,
                    ),
                    Text(
                      'ALBUM',
                      style: TextStyle(
                        letterSpacing: 4.0,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.queue_music,
                        color: theme.iconTheme.color,
                      ),
                      tooltip: 'Danh sách bài hát',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaylistScreen(
                              isDarkTheme: widget.isDarkTheme,
                              onToggleTheme: widget.onToggleTheme,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Vùng Đĩa Nhạc Xoay Tròn (Vinyl Disc Player)
              RotationTransition(
                turns: _rotationController,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withOpacity(0.6),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 210,
                      height: 210,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor.withOpacity(0.2),
                              width: 3,
                            ),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: primaryColor,
                            size: 38,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Thông tin bài hát
              Text(
                'SONG TITLE',
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 3.0,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'ARTIST NAME',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 2.0,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 20),

              // Bảng điều khiển phụ và nút bấm
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous, size: 28),
                      color: primaryColor,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 26,
                      ),
                      color: primaryColor,
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, size: 24),
                      color: primaryColor,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, size: 28),
                      color: primaryColor,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Thanh Progress Slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 12,
                    ),
                    activeTrackColor: primaryColor,
                    inactiveTrackColor: primaryColor.withOpacity(0.2),
                    thumbColor: primaryColor,
                  ),
                  child: Slider(
                    value: currentProgress,
                    onChanged: (val) {
                      setState(() {
                        currentProgress = val;
                      });
                    },
                  ),
                ),
              ),

              // Nút Play / Pause tròn ở dưới
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 4.0),
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
