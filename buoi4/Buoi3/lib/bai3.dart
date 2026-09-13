import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  final List<String> productImages = const [
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
    'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=600',
    'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=600',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        leading: const Icon(Icons.storefront, color: Colors.white),
        title: const Text(
          'Chi tiết sản phẩm',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Danh sách 03 hình ảnh sản phẩm (Cuộn ngang)
              Container(
                height: 230,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: productImages.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        productImages[index],
                        width: 260,
                        height: 210,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 260,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // 2. Thông tin cơ bản: Tên, Mã, Giá bán, Nhà sản xuất
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên sản phẩm
                    const Text(
                      'Tai nghe Bluetooth Chống Ồn Sony WH-1000XM5',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Mã sản phẩm
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECEFF1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Mã SP: SN-WH1000XM5-BLK',
                        style: TextStyle(
                          color: Color(0xFF455A64),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Giá bán
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Giá bán: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '7.990.000 ₫',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD32F2F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Nhà sản xuất
                    Row(
                      children: const [
                        Icon(
                          Icons.business,
                          size: 18,
                          color: Color(0xFF1976D2),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Nhà sản xuất: ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Sony Corporation',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF1976D2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 3. Mô tả sản phẩm
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(
                          Icons.description,
                          size: 20,
                          color: Color(0xFF0D47A1),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Mô tả sản phẩm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 20, thickness: 0.8),
                    Text(
                      'Tai nghe không dây chống ồn Sony WH-1000XM5 được thiết kế lại hoàn toàn với 8 micro và 2 bộ xử lý Auto NC Optimizer giúp khử tiếng ồn vượt trội.\n\n'
                      '• Trọng lượng siêu nhẹ với mút mềm vừa vặn, tạo cảm giác êm ái suốt ngày dài.\n'
                      '• Hỗ trợ chuẩn âm thanh Hi-Res Audio Wireless và codec LDAC.\n'
                      '• Thời lượng pin sử dụng liên tục lên đến 30 giờ và hỗ trợ sạc nhanh (sạc 3 phút dùng 3 giờ).\n'
                      '• Tích hợp tính năng Speak-to-Chat tự động dừng nhạc khi người dùng cất giọng nói.',
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.45,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
