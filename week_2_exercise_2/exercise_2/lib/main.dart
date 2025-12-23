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
      home: const ThucHanh03(),
    );
  }
}

class ThucHanh03 extends StatefulWidget {
  const ThucHanh03({super.key});

  @override
  State<ThucHanh03> createState() => _ThucHanh03State();
}

class _ThucHanh03State extends State<ThucHanh03> {
  // Controller để lấy dữ liệu từ 2 ô nhập liệu
  final TextEditingController _controllerA = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();
  
  String _result = ''; // Biến lưu kết quả hiển thị

  // Hàm thực hiện tính toán
  void _calculate(String operator) {
    setState(() {
      // Chuyển đổi dữ liệu nhập sang số thực (double)
      final double? a = double.tryParse(_controllerA.text);
      final double? b = double.tryParse(_controllerB.text);

      if (a == null || b == null) {
        _result = 'Vui lòng nhập số hợp lệ';
        return;
      }

      switch (operator) {
        case '+':
          _result = 'Kết quả: ${a + b}';
          break;
        case '-':
          _result = 'Kết quả: ${a - b}';
          break;
        case '*':
          _result = 'Kết quả: ${a * b}';
          break;
        case '/':
          if (b == 0) {
            _result = 'Không thể chia cho 0';
          } else {
            _result = 'Kết quả: ${a / b}';
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thực hành 03'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Ô nhập số a
            TextField(
              controller: _controllerA,
              decoration: const InputDecoration(
                hintText: 'Nhập số a',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            
            // Hàng chứa các nút phép tính
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOperatorButton('+', Colors.red),
                _buildOperatorButton('-', Colors.orange),
                _buildOperatorButton('*', Colors.blue),
                _buildOperatorButton('/', Colors.black),
              ],
            ),
            const SizedBox(height: 15),

            // Ô nhập số b
            TextField(
              controller: _controllerB,
              decoration: const InputDecoration(
                hintText: 'Nhập số b',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),

            // Hiển thị kết quả
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _result,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget con để tạo các nút phép tính nhanh hơn
  Widget _buildOperatorButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () => _calculate(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(60, 50),
      ),
      child: Text(label, style: const TextStyle(fontSize: 20)),
    );
  }
}