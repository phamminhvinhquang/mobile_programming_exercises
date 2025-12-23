import 'package:flutter/material.dart';

void main() {
  // Điểm khởi đầu của ứng dụng, chạy widget MyApp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Selection',
      debugShowCheckedModeBanner:
          false, // Tắt biểu tượng "Debug" ở góc màn hình
      theme: ThemeData(
        // Thiết lập bảng màu chủ đạo dựa trên màu xanh (blue)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true, // Sử dụng thiết kế Material Design 3 mới nhất
      ),
      // Màn hình chính của ứng dụng
      home: const PaymentPage(),
    );
  }
}

// ---------------------------------------------------------
// 1. Áp dụng OOP: Class đóng gói dữ liệu phương thức thanh toán
// ---------------------------------------------------------
class PaymentMethod {
  final String name; // Tên hiển thị (VD: PayPal)
  final IconData icon; // Biểu tượng (Icon)
  final Color color; // Màu sắc đặc trưng của phương thức đó

  PaymentMethod({required this.name, required this.icon, required this.color});
}

// ---------------------------------------------------------
// 2. Trang chọn phương thức thanh toán (StatefulWidget)
// ---------------------------------------------------------
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Khởi tạo danh sách các đối tượng phương thức thanh toán
  final List<PaymentMethod> _methods = [
    PaymentMethod(name: 'PayPal', icon: Icons.paypal, color: Colors.pink),
    PaymentMethod(
      name: 'GooglePay',
      icon: Icons.g_mobiledata,
      color: Colors.red,
    ),
    PaymentMethod(name: 'ApplePay', icon: Icons.apple, color: Colors.black),
  ];

  // Biến State: Lưu phương thức hiện đang được người dùng tích chọn
  // Có thể là null nếu người dùng chưa chọn gì
  PaymentMethod? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn hình thức thanh toán'),
        centerTitle: true, // Căn giữa tiêu đề AppBar
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // PHẦN 1: Hiển thị Logo lớn tương ứng với lựa chọn
            Expanded(
              flex: 2, // Chiếm 2 phần không gian
              child: Center(
                child: _selectedMethod == null
                    ? const Icon(
                        // Hiển thị mặc định nếu chưa chọn
                        Icons.add_to_photos_outlined,
                        size: 100,
                        color: Colors.grey,
                      )
                    : Column(
                        // Hiển thị thông tin phương thức đã chọn
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _selectedMethod!.icon,
                            size: 120,
                            color: _selectedMethod!.color,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _selectedMethod!.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // PHẦN 2: Danh sách các RadioListTile để lựa chọn
            Expanded(
              flex: 3, // Chiếm 3 phần không gian
              child: Column(
                // Duyệt qua danh sách _methods để tạo UI cho từng item
                children: _methods.map((method) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: RadioListTile<PaymentMethod>(
                      title: Text(method.name),
                      secondary: Icon(method.icon, color: method.color),
                      value: method, // Giá trị của nút radio này
                      groupValue: _selectedMethod, // Giá trị chung để so sánh
                      onChanged: (PaymentMethod? value) {
                        // Cập nhật State khi người dùng click chọn
                        setState(() {
                          _selectedMethod = value;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // PHẦN 3: Nút bấm xác nhận (Chỉ hiện khi _selectedMethod != null)
            if (_selectedMethod != null)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Hiển thị thông báo SnackBar khi nhấn Continue
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bạn đã chọn ${_selectedMethod!.name}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Continue', style: TextStyle(fontSize: 18)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
