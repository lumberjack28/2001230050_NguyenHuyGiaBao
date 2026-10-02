import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/sms_model.dart';

class SmsAnalyzerScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkTheme;

  const SmsAnalyzerScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkTheme,
  });

  @override
  State<SmsAnalyzerScreen> createState() => _SmsAnalyzerScreenState();
}

class _SmsAnalyzerScreenState extends State<SmsAnalyzerScreen> {
  final List<SmsMessageModel> _allMessages = List.from(sampleSmsList);
  String _searchSender = '';
  String _selectedFilter = 'ALL'; // 'ALL', 'QC', 'OTP'

  // Lọc danh sách theo số điện thoại và loại nhóm tin nhắn
  List<SmsMessageModel> get _filteredMessages {
    return _allMessages.where((sms) {
      final matchSender = sms.sender.toLowerCase().contains(
        _searchSender.trim().toLowerCase(),
      );

      bool matchCategory = true;
      if (_selectedFilter == 'QC') {
        matchCategory = sms.isAdvertisement;
      } else if (_selectedFilter == 'OTP') {
        matchCategory = sms.isOtp;
      }

      return matchSender && matchCategory;
    }).toList();
  }

  // Thống kê tin nhắn nhóm theo định dạng dd/MM/yyyy
  Map<String, int> get _messagesByDateStats {
    final Map<String, int> stats = {};
    for (var sms in _allMessages) {
      final dateKey =
          '${sms.date.day.toString().padLeft(2, '0')}/${sms.date.month.toString().padLeft(2, '0')}/${sms.date.year}';
      stats[dateKey] = (stats[dateKey] ?? 0) + 1;
    }
    return stats;
  }

  // Hộp thoại hiển thị mã OTP đã trích xuất
  void _showOtpDialog(SmsMessageModel sms) {
    final otp = sms.extractOtpCode() ?? 'Không tìm thấy';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.security, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text(
              'Mã OTP xác thực',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Chuỗi 6 ký số OTP được trích xuất từ tin nhắn:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.deepPurple.shade300,
                  width: 1.5,
                ),
              ),
              child: Text(
                otp,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6.0,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Người gửi: ${sms.sender}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Sao chép'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: otp));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã sao chép mã OTP: $otp'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Modal hiển thị bảng thống kê tin nhắn theo ngày/tháng
  void _showStatsModal() {
    final stats = _messagesByDateStats;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Thống kê theo Ngày/Tháng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: stats.entries.map((entry) {
                  return ListTile(
                    leading: const Icon(
                      Icons.calendar_month,
                      color: Colors.indigo,
                    ),
                    title: Text(
                      'Ngày ${entry.key}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${entry.value} tin nhắn',
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = _allMessages.length;
    final qcCount = _allMessages.where((m) => m.isAdvertisement).length;
    final otpCount = _allMessages.where((m) => m.isOtp).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SMS Analyzer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Thống kê theo ngày/tháng',
            icon: const Icon(Icons.bar_chart),
            onPressed: _showStatsModal,
          ),
          IconButton(
            tooltip: 'Đổi Theme Sáng / Tối',
            icon: Icon(widget.isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          // Thẻ tổng quan số lượng tin nhắn
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.isDarkTheme
                    ? [const Color(0xFF311B92), const Color(0xFF512DA8)]
                    : [const Color(0xFF673AB7), const Color(0xFF9575CD)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Tổng tin nhắn',
                  totalCount.toString(),
                  Icons.message,
                ),
                Container(width: 1, height: 40, color: Colors.white24),
                _buildStatItem('Quảng cáo', qcCount.toString(), Icons.campaign),
                Container(width: 1, height: 40, color: Colors.white24),
                _buildStatItem('Mã OTP', otpCount.toString(), Icons.password),
              ],
            ),
          ),

          // Ô tìm kiếm / lọc theo số điện thoại
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Lọc theo số điện thoại hoặc người gửi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchSender.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchSender = ''),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) => setState(() => _searchSender = val),
            ),
          ),

          // Các nút phân nhóm (Chips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                _buildFilterChip('Tất cả', 'ALL', totalCount),
                const SizedBox(width: 8),
                _buildFilterChip('Quảng cáo [QC]', 'QC', qcCount),
                const SizedBox(width: 8),
                _buildFilterChip('Mã xác thực [OTP]', 'OTP', otpCount),
              ],
            ),
          ),

          const Divider(height: 1),

          // Danh sách tin nhắn hiển thị
          Expanded(
            child: _filteredMessages.isEmpty
                ? const Center(
                    child: Text(
                      'Không tìm thấy tin nhắn phù hợp',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredMessages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final sms = _filteredMessages[index];
                      final isOtp = sms.isOtp;
                      final isQc = sms.isAdvertisement;

                      return Card(
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isOtp
                                ? Colors.deepPurple.shade300
                                : isQc
                                ? Colors.orange.shade300
                                : Colors.transparent,
                            width: (isOtp || isQc) ? 1.5 : 0,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: isOtp ? () => _showOtpDialog(sms) : null,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: isOtp
                                              ? Colors.deepPurple.withOpacity(
                                                  0.2,
                                                )
                                              : (isQc
                                                    ? Colors.orange.withOpacity(
                                                        0.2,
                                                      )
                                                    : Colors.blue.withOpacity(
                                                        0.2,
                                                      )),
                                          child: Icon(
                                            isOtp
                                                ? Icons.key
                                                : (isQc
                                                      ? Icons.campaign
                                                      : Icons.person),
                                            size: 18,
                                            color: isOtp
                                                ? Colors.deepPurple
                                                : (isQc
                                                      ? Colors.orange
                                                      : Colors.blue),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          sms.sender,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${sms.date.hour.toString().padLeft(2, '0')}:${sms.date.minute.toString().padLeft(2, '0')} - ${sms.date.day}/${sms.date.month}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  sms.body,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.3,
                                  ),
                                ),
                                if (isOtp) ...[
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.deepPurple.shade200,
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.touch_app,
                                            size: 14,
                                            color: Colors.deepPurple,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Chạm để lấy mã OTP',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String filterKey, int count) {
    final isSelected = _selectedFilter == filterKey;
    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedFilter = filterKey);
        }
      },
    );
  }
}
