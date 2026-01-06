import 'package:flutter/material.dart';

// Hàm main: Điểm khởi đầu của mọi ứng dụng Flutter
void main() {
  runApp(const MyApp());
}

// Widget MyApp: Cấu hình chính cho toàn bộ ứng dụng (Theme, Tiêu đề, Trang chính)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Tắt biểu tượng "Debug" ở góc màn hình
      title: 'UI Components HW',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ), // Tạo bộ màu dựa trên màu xanh
        useMaterial3: true, // Sử dụng bộ giao diện Material 3 mới nhất
        // Chỉnh sửa giao diện chung cho thanh AppBar của tất cả các màn hình
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.blue),
        ),
      ),
      home:
          const ComponentsListScreen(), // Màn hình đầu tiên xuất hiện khi mở app
    );
  }
}

// --- MÀN HÌNH 1: DANH SÁCH CÁC THÀNH PHẦN (LIST SCREEN) ---
class ComponentsListScreen extends StatelessWidget {
  const ComponentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách dữ liệu mẫu để hiển thị lên ListView
    final List<Map<String, dynamic>> components = [
      {
        'category': 'Display',
        'title': 'Text',
        'desc': 'Displays text',
        'route': 'Text',
      },
      {
        'category': 'Display',
        'title': 'Image',
        'desc': 'Displays an image',
        'route': 'Image',
      },
      {
        'category': 'Input',
        'title': 'TextField',
        'desc': 'Input field for text',
        'route': 'TextField',
      },
      {
        'category': 'Input',
        'title': 'PasswordField',
        'desc': 'Input field for passwords',
        'route': 'PasswordField',
      },
      {
        'category': 'Layout',
        'title': 'Column',
        'desc': 'Arranges elements vertically',
        'route': 'Column',
      },
      {
        'category': 'Layout',
        'title': 'Row',
        'desc': 'Arranges elements horizontally',
        'route': 'Row',
      },
      {
        'category': 'Controls',
        'title': 'Button & Input',
        'desc': 'Buttons, Checkbox, Switch...',
        'route': 'Button',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('UI Components List')),
      body: Column(
        children: [
          // Expanded giúp ListView chiếm trọn không gian còn trống trừ phần nút bấm ở dưới
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: components.length,
              itemBuilder: (context, index) {
                final item = components[index];
                // Logic hiển thị Tiêu đề nhóm (Category): Nếu là phần tử đầu tiên hoặc nhóm khác phần tử trước đó
                bool showHeader =
                    index == 0 ||
                    components[index - 1]['category'] != item['category'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: Text(
                          item['category'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    _buildCustomCard(
                      context,
                      item,
                    ), // Gọi hàm vẽ ô card cho từng item
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Hàm tạo giao diện cho từng thẻ Card trong danh sách
  Widget _buildCustomCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFBBDEFB), // Màu nền xanh nhạt
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          item['title'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: item['desc'].isNotEmpty
            ? Text(item['desc'], style: const TextStyle(fontSize: 13))
            : null,
        onTap: () {
          // Khi bấm vào: Chuyển sang màn hình DetailScreen và truyền tiêu đề đi
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(title: item['route']),
            ),
          );
        },
      ),
    );
  }
}

// --- MÀN HÌNH CHI TIẾT (DETAIL SCREEN) ---
// Sử dụng StatefulWidget vì nội dung thay đổi được (khi gõ chữ, chọn checkbox...)
class DetailScreen extends StatefulWidget {
  final String title;
  const DetailScreen({super.key, required this.title});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Các biến lưu trữ trạng thái người dùng thao tác
  String _inputText = ""; // Lưu trữ chữ người dùng gõ
  bool _isChecked = false; // Trạng thái ô Checkbox
  bool _isSwitched = true; // Trạng thái nút Switch (Gạt)
  int _radioValue = 1; // Giá trị chọn phái (Nam/Nữ)
  double _sliderValue = 0.3; // Giá trị thanh trượt Audio

  @override
  Widget build(BuildContext context) {
    String displayTitle = widget.title;
    if (widget.title == 'Row') displayTitle = 'Row Layout';

    return Scaffold(
      appBar: AppBar(title: Text(displayTitle)),
      body: SingleChildScrollView(
        // Cho phép cuộn trang nếu nội dung dài quá màn hình
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildContent(
            widget.title,
          ), // Vẽ nội dung tùy theo loại Component được chọn
        ),
      ),
    );
  }

  // Hàm "Switch-case" để quyết định vẽ giao diện gì cho từng mục
  Widget _buildContent(String type) {
    switch (type) {
      case 'Text':
        // Sử dụng RichText để viết nhiều kiểu chữ (màu sắc, kích cỡ) trên cùng 1 dòng
        return Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(fontSize: 24, color: Colors.black),
              children: [
                TextSpan(text: 'The quick '),
                TextSpan(
                  text: 'Brown',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: '\nfox '),
                TextSpan(text: 'j u m p s', style: TextStyle(fontSize: 20)),
                TextSpan(
                  text: ' over',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '\nthe ',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(
                  text: 'lazy dog.',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        );

      case 'Image':
        return Column(
          children: [
            // Hiển thị hình ảnh từ thư mục assets đã khai báo trong pubspec.yaml
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // Bo tròn góc ảnh
              child: Image.asset(
                'assets/images/banner.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Banner trường UTH (Local Asset)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            // Ảnh thứ 2 (Logo) nằm trong khung Container
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/images/logo.jpg', fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            const Text('Logo UTH - In app'),
          ],
        );

      case 'TextField':
        return Column(
          children: [
            const SizedBox(height: 50),
            TextField(
              onChanged: (text) => setState(
                () => _inputText = text,
              ), // Cập nhật chữ mỗi khi người dùng gõ
              decoration: InputDecoration(
                hintText: 'Thông tin nhập',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tự động cập nhật dữ liệu theo ',
              style: TextStyle(color: Colors.red),
            ),
            // Nếu có chữ gõ thì hiển thị dòng Text bên dưới
            if (_inputText.isNotEmpty)
              Text(
                _inputText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        );

      case 'PasswordField':
        return Column(
          children: [
            const SizedBox(height: 50),
            TextField(
              obscureText: true, // Chế độ ẩn chữ (mật khẩu)
              onChanged: (text) => setState(() => _inputText = text),
              decoration: InputDecoration(
                hintText: 'Nhập mật khẩu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tự động cập nhật dữ liệu theo ',
              style: TextStyle(color: Colors.red),
            ),
            // Hiển thị mật khẩu dưới dạng dấu chấm (•) bằng cách nhân chuỗi
            if (_inputText.isNotEmpty)
              Text(
                '•' * _inputText.length,
                style: const TextStyle(fontSize: 30, letterSpacing: 2),
              ),
          ],
        );

      case 'Button':
        return Column(
          children: [
            const Text(
              "Buttons",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Wrap giúp các nút tự động xuống hàng nếu thiếu diện tích ngang
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("Elevated")),
                OutlinedButton(onPressed: () {}, child: const Text("Outlined")),
                TextButton(onPressed: () {}, child: const Text("Text")),
              ],
            ),
            const Divider(height: 40), // Dòng kẻ phân chia
            const Text(
              "Selection Controls",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Các widget chọn lựa (Checkbox, Switch, Radio)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (v) => setState(() => _isChecked = v!),
                ),
                const Text("Checkbox"),
                Switch(
                  value: _isSwitched,
                  onChanged: (v) => setState(() => _isSwitched = v),
                ),
                const Text("Switch"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: (v) => setState(() => _radioValue = v as int),
                ),
                const Text("Nam"),
                Radio(
                  value: 2,
                  groupValue: _radioValue,
                  onChanged: (v) => setState(() => _radioValue = v as int),
                ),
                const Text("Nữ"),
              ],
            ),
            const Divider(height: 40),
            // Mô phỏng giao diện chơi nhạc sử dụng Slider và Icon
          ],
        );

      case 'Row':
        // Hiển thị nhiều ô vuông lặp lại để demo Layout Row & Column
        return Column(
          children: List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: _buildRowOfBoxes(),
            ),
          ),
        );

      case 'Column':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.blue[300],
              height: 60,
              width: 200,
              margin: const EdgeInsets.all(5),
            ),
            Container(
              color: Colors.blue[500],
              height: 60,
              width: 200,
              margin: const EdgeInsets.all(5),
            ),
            Container(
              color: Colors.blue[700],
              height: 60,
              width: 200,
              margin: const EdgeInsets.all(5),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Column Layout",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );

      default:
        return const Center(child: Text("Nội dung chưa cập nhật"));
    }
  }

  // Hàm phụ vẽ 1 hàng chứa 3 ô vuông cho Layout Row demo
  Widget _buildRowOfBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(2, (index) => _blueBox()),
    );
  }

  // Hàm phụ tạo 1 ô vuông màu xanh có bo góc
  Widget _blueBox() {
    return Container(
      width: 80,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF64B5F6),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
