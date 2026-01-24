import 'package:flutter/material.dart';
import 'dart:async';
import 'global_data.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});
  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) { //5s kiểm tra đơn hết hạn sẽ xóa
      if (mounted) {
        setState(() {
          final now = DateTime.now();
          purchasedOrders.removeWhere( //xóa đơn hàng
            (order) =>
                order.scheduledTime != null &&
                DateTime.now().isAfter(order.scheduledTime!), //kiểm tra tg có quá hạn kh
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đơn hàng đã đặt')),
      //kiểm tra điều kiện
      body: purchasedOrders.isEmpty
          ? const Center(child: Text('Chưa có đơn hàng nào.'))
          : ListView.builder(
              itemCount: purchasedOrders.length,
              itemBuilder: (context, index) {
                final order = purchasedOrders[index];
                final remaining = order.scheduledTime!.difference(
                  DateTime.now(),
                );

                // Tính tổng tiền cho món này
                final totalItemPrice = order.drink.price * order.quantity;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        order.drink.imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    title: Text(
                      order.drink.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- HIỂN THỊ SIZE, SL, TIỀN ---
                        Text(
                          'Size: ${order.size} | Đường: ${order.sugarLevel.toInt()}% | SL: ${order.quantity}  Tổng: ${totalItemPrice.toInt()} VNĐ',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // --- HIỂN THỊ THỜI GIAN CÒN LẠI ---
                        if (order.note.isNotEmpty)
                          Text(
                            'Ghi chú: ${order.note}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        Text(
                          'Đơn hàng sẽ được giao sau: ${remaining.inMinutes}p ${remaining.inSeconds % 60}s',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 10,
                          ),
                        ),

                        // --- HIỂN THỊ GHI CHÚ NẾU CÓ ---
                      ],
                    ),
                    trailing: const Badge(
                      label: Text('Đang xử lý'),
                      backgroundColor: Colors.green,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
