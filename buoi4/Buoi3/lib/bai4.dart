import 'package:flutter/material.dart';

class Member {
  final String mssv;
  final String name;
  final String role;
  final bool isLeader;

  const Member({
    required this.mssv,
    required this.name,
    required this.role,
    this.isLeader = false,
  });
}

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({super.key});

  final List<Member> members = const [
    Member(
      mssv: '2001220001',
      name: 'Nguyễn Văn An',
      role: 'Nhóm trưởng',
      isLeader: true,
    ),
    Member(mssv: '2001220002', name: 'Trần Thị Bình', role: 'Thành viên'),
    Member(mssv: '2001220003', name: 'Lê Hoàng Cường', role: 'Thành viên'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        leading: const Icon(Icons.groups, color: Colors.white),
        title: const Text(
          'Thông tin nhóm',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card thông tin chung của nhóm
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mã nhóm Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EAF6),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF9FA8DA)),
                        ),
                        child: const Text(
                          'MÃ NHÓM: GROUP_08',
                          style: TextStyle(
                            color: Color(0xFF283593),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tên nhóm
                      const Text(
                        'Nhóm Phát Triển Ứng Dụng Di Động',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Số lượng thành viên
                      Row(
                        children: const [
                          Icon(Icons.people_alt, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Text(
                            'Số lượng thành viên: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '03',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFD32F2F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Tiêu đề danh sách thành viên
              const Row(
                children: [
                  Icon(Icons.badge, color: Color(0xFF0D47A1), size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Danh sách thành viên',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Danh sách 3 thành viên
              ...members.map((member) => _buildMemberCard(member)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCard(Member member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            // Icon đại diện
            CircleAvatar(
              radius: 24,
              backgroundColor: member.isLeader
                  ? const Color(0xFFFFF3E0)
                  : const Color(0xFFE3F2FD),
              child: Icon(
                member.isLeader ? Icons.star : Icons.person,
                color: member.isLeader
                    ? const Color(0xFFF57C00)
                    : const Color(0xFF1976D2),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // Tên và MSSV
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'MSSV: ${member.mssv}',
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // Nhãn vai trò (Nhóm trưởng / Thành viên)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: member.isLeader
                    ? const Color(0xFFFFF8E1)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: member.isLeader
                      ? const Color(0xFFFFB300)
                      : const Color(0xFFB0BEC5),
                ),
              ),
              child: Text(
                member.role,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: member.isLeader
                      ? const Color(0xFFE65100)
                      : const Color(0xFF455A64),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
