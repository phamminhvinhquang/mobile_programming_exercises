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
      // Đã sửa: ThựcHành02 -> ThucHanh02
      home: const ThucHanh02(),
    );
  }
}

// Đã sửa: ThựcHành02 -> ThucHanh02 (Không dùng dấu tiếng Việt trong tên Class)
class ThucHanh02 extends StatefulWidget {
  const ThucHanh02({super.key});

  @override
  State<ThucHanh02> createState() => _ThucHanh02State();
}

// Đã sửa: _ThựcHành02State -> _ThucHanh02State
class _ThucHanh02State extends State<ThucHanh02> {
  final TextEditingController _controller = TextEditingController();
  int _count = 0;
  String _errorMessage = '';

  void _handleCreate() {
    setState(() {
      final int? input = int.tryParse(_controller.text);

      if (input == null || input < 0) {
        _count = 0;
        _errorMessage = 'Dữ liệu bạn nhập không hợp lệ';
      } else {
        _count = input;
        _errorMessage = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thực hành 02',
        ), // Trong chuỗi Text thì dùng dấu bình thường
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nhập vào số lượng',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _handleCreate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: const Text('Tạo'),
                ),
              ],
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _count,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
