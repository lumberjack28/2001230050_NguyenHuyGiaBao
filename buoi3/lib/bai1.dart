import 'package:flutter/material.dart';

class StudentInfoScreen extends StatelessWidget {
  const StudentInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        leading: const Icon(Icons.home, color: Colors.black87),
        title: const Text(
          'Thông tin sinh viên',
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Ảnh đại diện dạng tròn
              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
                      ),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Họ và tên
              const Text(
                'Họ và tên: Nguyễn Văn A',
                style: TextStyle(
                  color: Color(0xFF2800D7),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Danh sách thông tin
              _buildTextItem('MSSV: 2001221234', const Color(0xFFD32F2F)),
              _buildTextItem('Lớp: 13DHTH02', const Color(0xFFD32F2F)),
              _buildTextItem('Khóa: 13 Đại học', const Color(0xFFD32F2F)),
              _buildTextItem(
                'Ngành: Công nghệ thông tin',
                const Color(0xFFD32F2F),
              ),
              _buildTextItem(
                'Trường: Đại học Công Thương\nThành phố Hồ Chí Minh',
                const Color(0xFFD32F2F),
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 140,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LecturerInfoScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F4F9),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: const Text(
                      'Trở về',
                      style: TextStyle(color: Color(0xFF5C6BC0), fontSize: 13),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          height: 1.25,
        ),
      ),
    );
  }
}

// ---------------- MÀN HÌNH 2: THÔNG TIN GIẢNG VIÊN ----------------
class LecturerInfoScreen extends StatelessWidget {
  const LecturerInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thông tin sinh viên',
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Ảnh đại diện
              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Tên giảng viên
              const Center(
                child: Text(
                  'Giảng viên Trần Thị A',
                  style: TextStyle(
                    color: Color(0xFF2800D7),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Thông tin chuyên môn
              _buildTextItem(
                'Khoa: Công nghệ Thông tin',
                const Color(0xFFD32F2F),
              ),
              _buildTextItem('Học hàm: Thạc sỹ', const Color(0xFFD32F2F)),
              _buildTextItem('Chuyên ngành: CNPM', const Color(0xFF00C853)),
              _buildTextItem(
                'Giảng dạy: Nhập môn lập trình, Lập trình windows, Lập trình we...',
                const Color(0xFF1E88E5),
              ),
              const Spacer(),
              // Nút Trở về -> Quay lại màn hình trước
              Center(
                child: SizedBox(
                  width: 140,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F4F9),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: const Text(
                      'Trở về',
                      style: TextStyle(color: Color(0xFF5C6BC0), fontSize: 13),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          height: 1.25,
        ),
      ),
    );
  }
}
