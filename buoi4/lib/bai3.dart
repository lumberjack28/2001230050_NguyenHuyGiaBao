import 'package:flutter/material.dart';

class Bai3Screen extends StatefulWidget {
  const Bai3Screen({super.key});

  @override
  State<Bai3Screen> createState() => _Bai3ScreenState();
}

class _Bai3ScreenState extends State<Bai3Screen> {
  int _selectedMoodIndex = 1; // Mặc định chọn "Fine"
  int _selectedBottomNavIndex = 0;

  final List<Map<String, String>> _moods = [
    {'emoji': '😩', 'label': 'Bad'},
    {'emoji': '🙂', 'label': 'Fine'},
    {'emoji': '😁', 'label': 'Well'},
    {'emoji': '🥳', 'label': 'Excellent'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2675EB), // Màu nền xanh dương chính
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Phần Header và Mood Tracker (Nền xanh)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  // Dòng Chào mừng & Thông báo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Hi, Jared!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Padding(
                            padding: EdgeInsets.only(left: 32.0),
                            child: Text(
                              '23 Jan, 2021',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF90B9F8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4086ED),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Thanh tìm kiếm Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF4086ED),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.white, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Search',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tiêu đề "How do you feel?"
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'How do you feel?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(Icons.more_horiz, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Danh sách các trạng thái cảm xúc (Mood items)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_moods.length, (index) {
                      final item = _moods[index];
                      final isSelected = _selectedMoodIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMoodIndex = index;
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF1E5EC1) : const Color(0xFF4086ED),
                                borderRadius: BorderRadius.circular(16),
                                border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                item['emoji']!,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['label']!,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Phần Exercises bo tròn nền xám nhạt
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Exercises',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Icon(Icons.more_horiz, color: Colors.black54),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _buildExerciseCard(
                            icon: Icons.favorite,
                            iconBgColor: Colors.orange,
                            title: 'Speaking Skills',
                            subtitle: '16 Exercises',
                          ),
                          const SizedBox(height: 12),
                          _buildExerciseCard(
                            icon: Icons.person,
                            iconBgColor: Colors.green,
                            title: 'Reading Skills',
                            subtitle: '8 Exercises',
                          ),
                          const SizedBox(height: 12),
                          _buildExerciseCard(
                            icon: Icons.star,
                            iconBgColor: const Color(0xFFE91E63),
                            title: 'Writing Skills',
                            subtitle: '20 Exercises',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedBottomNavIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xFF2675EB),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.more_horiz, color: Colors.black45),
        ],
      ),
    );
  }
}