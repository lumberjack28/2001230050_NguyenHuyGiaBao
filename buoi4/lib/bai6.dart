import 'package:flutter/material.dart';

class Bai6Screen extends StatefulWidget {
  const Bai6Screen({super.key});

  @override
  State<Bai6Screen> createState() => _Bai6ScreenState();
}

class _Bai6ScreenState extends State<Bai6Screen> {
  bool _isPlaying = false;
  bool _isFavorite = true;
  double _progress = 0.65; // Vị trí thanh tiến trình

  // Màu nền chủ đạo phong cách Neumorphism
  final Color _bgColor = const Color(0xFFE0E5EC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Top Bar: Nút Back, Title Playlist, Nút Menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNeuButton(
                    size: 48,
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.black54, size: 20),
                  ),
                  const Text(
                    'P L A Y L I S T',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.black54,
                    ),
                  ),
                  _buildNeuButton(
                    size: 48,
                    onTap: () {},
                    child: const Icon(Icons.menu, color: Colors.black54, size: 20),
                  ),
                ],
              ),

              // 2. Card Album Art & Thông tin bài hát
              _buildNeuContainer(
                padding: const EdgeInsets.all(12),
                borderRadius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hình ảnh bìa Album
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        'https://picsum.photos/seed/music_cover/500/400',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.music_note, size: 80, color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tên bài hát & nút Yêu thích
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Kota The Friend',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Birdie',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFavorite = !_isFavorite;
                              });
                            },
                            child: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorite ? Colors.redAccent : Colors.black38,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Thời gian và các nút Shuffle / Repeat
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('0:00', style: TextStyle(color: Colors.black45, fontSize: 12)),
                        Row(
                          children: const [
                            Icon(Icons.shuffle, size: 20, color: Colors.black45),
                            SizedBox(width: 24),
                            Icon(Icons.repeat, size: 20, color: Colors.black45),
                          ],
                        ),
                        const Text('4:22', style: TextStyle(color: Colors.black45, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Thanh tiến trình (Progress Bar dạng đổ bóng chìm)
                  _buildNeuProgressBar(),
                ],
              ),

              // 4. Các nút điều khiển phát nhạc (Previous, Play/Pause, Next)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildNeuControlButton(
                      onTap: () {},
                      child: const Icon(Icons.skip_previous, color: Colors.black87, size: 28),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: _buildNeuControlButton(
                      onTap: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                      },
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black87,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildNeuControlButton(
                      onTap: () {},
                      child: const Icon(Icons.skip_next, color: Colors.black87, size: 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // Khung chứa Neumorphism với bóng sáng phía trên-trái và bóng tối phía dưới-phải
  Widget _buildNeuContainer({
    required Widget child,
    EdgeInsetsGeometry? padding,
    double borderRadius = 16,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: const Color(0xFFA3B1C6).withValues(alpha: 0.6),
            offset: const Offset(6, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }

  // Nút bấm tròn/vuông nhỏ Neumorphism
  Widget _buildNeuButton({
    required Widget child,
    required VoidCallback onTap,
    double size = 48,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: const Color(0xFFA3B1C6).withValues(alpha: 0.6),
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  // Nút điều khiển phát nhạc hình chữ nhật bo góc
  Widget _buildNeuControlButton({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-5, -5),
              blurRadius: 10,
            ),
            BoxShadow(
              color: const Color(0xFFA3B1C6).withValues(alpha: 0.6),
              offset: const Offset(5, 5),
              blurRadius: 10,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  // Thanh tiến trình phong cách lõm sâu (Inner shadow)
  Widget _buildNeuProgressBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        return GestureDetector(
          onTapDown: (details) {
            setState(() {
              _progress = (details.localPosition.dx / totalWidth).clamp(0.0, 1.0);
            });
          },
          child: Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFD6DBE4),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA3B1C6).withValues(alpha: 0.5),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-2, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
            child: Container(
              width: totalWidth * _progress,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50), // Màu xanh lá như mẫu
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }
}