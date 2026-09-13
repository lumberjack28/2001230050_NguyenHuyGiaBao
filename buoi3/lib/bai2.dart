import 'package:flutter/material.dart';

class ThesisTopicScreen extends StatelessWidget {
  const ThesisTopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        leading: const Icon(Icons.school, color: Colors.white),
        title: const Text(
          'Thông tin đề tài khóa luận',
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
              // Card thông tin chính
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mã đề tài (Badge nhỏ)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF90CAF9)),
                        ),
                        child: const Text(
                          'MÃ ĐỀ TÀI: KLTN_2026_01',
                          style: TextStyle(
                            color: Color(0xFF0D47A1),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tên đề tài
                      const Text(
                        'Xây dựng ứng dụng di động hỗ trợ quản lý học tập và nghiên cứu',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                          height: 1.3,
                        ),
                      ),
                      const Divider(height: 24, thickness: 1),

                      // Chi tiết thông số
                      _buildInfoRow(
                        icon: Icons.group,
                        label: 'Số lượng sinh viên tối đa:',
                        value: '02 sinh viên',
                      ),
                      const SizedBox(height: 10),
                      _buildInfoRow(
                        icon: Icons.computer,
                        label: 'Chuyên ngành:',
                        value: 'Công nghệ phần mềm',
                      ),
                      const SizedBox(height: 10),
                      _buildInfoRow(
                        icon: Icons.person_pin,
                        label: 'Giảng viên hướng dẫn:',
                        value: 'ThS. Nguyễn Văn B',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card yêu cầu đề tài
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.assignment_turned_in,
                            color: Color(0xFFD32F2F),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Yêu cầu đề tài',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD32F2F),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildRequirementItem(
                        'Nắm vững kiến thức lập trình di động đa nền tảng (Flutter/Dart).',
                      ),
                      _buildRequirementItem(
                        'Có khả năng thiết kế kiến trúc hệ thống, cơ sở dữ liệu và RESTful API.',
                      ),
                      _buildRequirementItem(
                        'Hoàn thiện tài liệu phân tích thiết kế hệ thống theo đúng chuẩn khoa CNTT.',
                      ),
                      _buildRequirementItem(
                        'Có tinh thần chủ động, báo cáo tiến độ định kỳ hàng tuần với GVHD.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị dòng thông tin có icon
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1E88E5)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              children: [
                TextSpan(
                  text: '$label ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget hiển thị gạch đầu dòng yêu cầu
  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.35,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
