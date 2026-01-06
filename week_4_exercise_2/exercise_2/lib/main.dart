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
      title: 'List Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

// --- MÀN HÌNH CHÍNH (CHỌN LOẠI LIST) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose List Type',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nút MÀU XANH: Dùng ListView thường
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), // Màu xanh lá
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StandardListScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'ListView (10000000 items)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Nút MÀU VÀNG: Dùng ListView.builder
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800), // Màu vàng cam
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BuilderListScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'ListView.builder (10000000 items)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- MÀN HÌNH 1: DÙNG LISTVIEW THƯỜNG (STANDARD) ---
class StandardListScreen extends StatelessWidget {
  const StandardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TẠO DỮ LIỆU TRƯỚC:
    // List.generate sẽ tạo ra 1000 widget ngay lập tức khi hàm build chạy.
    // Điều này tốn bộ nhớ nếu danh sách rất lớn.
    List<Widget> listItems = List.generate(
      10000000,
      (index) => _buildItemCard(index),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView Standard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // Truyền trực tiếp danh sách widget vào children
      body: ListView(padding: const EdgeInsets.all(10), children: listItems),
    );
  }
}

// --- MÀN HÌNH 2: DÙNG LISTVIEW.BUILDER (LAZY LOADING) ---
class BuilderListScreen extends StatelessWidget {
  const BuilderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView.builder'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // ListView.builder chỉ tạo widget khi người dùng cuộn tới nó
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 10000000, // Số lượng phần tử
        itemBuilder: (context, index) {
          // Hàm này được gọi mỗi lần một item xuất hiện trên màn hình
          return _buildItemCard(index);
        },
      ),                                                                                                                                                                                
    );
  }
}

// --- HÀM VẼ GIAO DIỆN CHO 1 ITEM (Dùng chung để so sánh) ---
Widget _buildItemCard(int index) {
  return Card(
    color: Colors.blue.shade50, // Màu nền xanh nhạt giống ảnh
    margin: const EdgeInsets.symmetric(vertical: 5),
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: ListTile(
      leading: Text(
        '${index + 1}', // Số thứ tự (bắt đầu từ 1)
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      title: const Text(
        'The only way to do great work\nis to love what you do.',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.arrow_forward, size: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        // Hành động khi bấm vào item (nếu cần)
        debugPrint('Bấm vào item số ${index + 1}');
      },
    ),
  );
}
