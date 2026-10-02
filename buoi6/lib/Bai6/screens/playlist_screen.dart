import 'package:flutter/material.dart';

import '../models/song_model.dart';

class PlaylistScreen extends StatelessWidget {
  final bool isDarkTheme;
  final VoidCallback onToggleTheme;

  const PlaylistScreen({
    super.key,
    required this.isDarkTheme,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'SONG TITLE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            Text(
              'ARTIST',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.5,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkTheme ? Icons.light_mode : Icons.dark_mode,
              color: theme.iconTheme.color,
            ),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          // Khu vực Controller thu nhỏ phía trên
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // Slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    activeTrackColor: primaryColor,
                    inactiveTrackColor: primaryColor.withOpacity(0.2),
                    thumbColor: primaryColor,
                  ),
                  child: Slider(value: 0.6, onChanged: (val) {}),
                ),
                // Nút chuyển bài và Play/Pause nhỏ
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      color: primaryColor,
                      iconSize: 30,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        color: Colors.white,
                        iconSize: 28,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      color: primaryColor,
                      iconSize: 30,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Danh sách bài hát
          Expanded(
            child: ListView.separated(
              itemCount: sampleSongs.length,
              separatorBuilder: (context, index) => Divider(
                color: primaryColor.withOpacity(0.15),
                height: 1,
                indent: 64,
                endIndent: 20,
              ),
              itemBuilder: (context, index) {
                final song = sampleSongs[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24,
                        child: Text(
                          '${song.id}.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.music_note,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    song.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  subtitle: Text(
                    song.artist,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.6,
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        song.duration,
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(
                            0.6,
                          ),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.more_vert,
                        size: 20,
                        color: theme.iconTheme.color?.withOpacity(0.5),
                      ),
                    ],
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
