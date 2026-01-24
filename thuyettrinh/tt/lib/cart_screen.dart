import 'package:flutter/material.dart';
import 'models.dart';
import 'global_data.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> _showNoteDialog(int index) async {
    final controller = TextEditingController(
      text: globalCart[index].note,
    ); //lưu dữ liệu không bị mất
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm ghi chú'),
        content: TextField(
          controller: controller,
          autofocus: true, //bán phím tự động bật
          decoration: const InputDecoration(
            hintText: "VD: Ít đá...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() => globalCart[index].note = controller.text);
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCheckout() async {
    final selectedItems = globalCart.where((item) => item.isSelected).toList();
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng tích chọn món!')));
      return;
    }
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), //kh chọn ngày quá khứ
      lastDate: DateTime.now().add(
        const Duration(days: 7),
      ), //đặt trước tối đa 7d
    );
    if (pickedDate == null) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    setState(() {
      final finalTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      for (var item in selectedItems) {
        item.scheduledTime = finalTime;
      }
      purchasedOrders.addAll(selectedItems); //chuyển qua purchase
      globalCart.removeWhere((item) => item.isSelected); //xóa khỏi giỏ hàng
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('🎉 Đặt hàng thành công!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      //kiểm tra giỏ hàng
      body: globalCart.isEmpty
          ? const Center(child: Text('Giỏ hàng trống'))
          : ListView.builder(
              itemCount: globalCart.length,
              itemBuilder: (context, index) {
                final item = globalCart[index];
                return Dismissible(
                  //vuốt sang phải để xóa
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (dir) =>
                      setState(() => globalCart.removeAt(index)),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  //checkbox
                  child: CheckboxListTile(
                    value: item.isSelected,
                    onChanged: (val) => setState(() => item.isSelected = val!),
                    secondary: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item.drink.imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item.drink.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Size: ${item.size} | Đường: ${item.sugarLevel.toInt()}% | SL: ${item.quantity}          Tổng: ${(item.drink.price * item.quantity).toInt()} VNĐ',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        InkWell(
                          onTap: () => _showNoteDialog(index),
                          child: Row(
                            children: [
                              const Text(
                                "Ghi chú: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.note.isEmpty
                                      ? "Bấm để thêm..."
                                      : item.note,
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: item.note.isEmpty
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      //nút đặt hàng
      bottomNavigationBar: globalCart.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: _handleCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'ĐẶT HÀNG',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            )
          : null,
    );
  }
}
