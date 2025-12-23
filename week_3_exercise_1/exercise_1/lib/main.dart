import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ví dụ về Nullable',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const NullableExampleScreen(),
    );
  }
}

class NullableExampleScreen extends StatefulWidget {
  const NullableExampleScreen({super.key});

  @override
  State<NullableExampleScreen> createState() => _NullableExampleScreenState();
}

class _NullableExampleScreenState extends State<NullableExampleScreen> {
  // 1. Khai báo biến Nullable với dấu '?'
  String? userName;

  void _updateName() {
    setState(() {
      // Giả lập việc nhận dữ liệu (có lúc có tên, có lúc null)
      userName = (userName == null) ? "Nguyễn Văn A" : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 2. Sử dụng toán tử '??' để cung cấp giá trị mặc định
    String displayName = userName ?? "Khách hàng ẩn danh";

    return Scaffold(
      appBar: AppBar(title: const Text("Tìm hiểu Nullable")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              "Xin chào,",
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            Text(
              displayName, // Hiển thị giá trị đã xử lý null
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateName,
              child: Text(
                userName == null ? "Đăng nhập" : "Đăng xuất (Set null)",
              ),
            ),
            const SizedBox(height: 10),
            // 3. Sử dụng null-aware access '?.'
            Text("Độ dài tên: ${userName?.length ?? 0}"),
          ],
        ),
      ),
    );
  }
}
