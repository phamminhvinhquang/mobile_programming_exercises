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
      title: 'UI Components HW',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
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
      home: const ComponentsListScreen(),
    );
  }
}

// --- MÀN HÌNH 1: LIST SCREEN ---
class ComponentsListScreen extends StatelessWidget {
  const ComponentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> components = [
      // Display Group
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

      // Input Group
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

      // Layout Group
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: components.length,
              itemBuilder: (context, index) {
                final item = components[index];
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
                    _buildCustomCard(context, item),
                  ],
                );
              },
            ),
          ),

          // Nút Button cố định ở dưới
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Button Pressed!')),
                  );
                },
                child: const Text("Button", style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFBBDEFB),
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
          if (item['route'] != 'Unknown') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(title: item['route']),
              ),
            );
          }
        },
      ),
    );
  }
}

// --- MÀN HÌNH CHI TIẾT ---
class DetailScreen extends StatefulWidget {
  final String title;
  const DetailScreen({super.key, required this.title});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _inputText = "";

  bool _isChecked = false;
  bool _isSwitched = true;
  int _radioValue = 1;
  double _sliderValue = 0.3; // Giá trị giả lập cho Audio Slider

  @override
  Widget build(BuildContext context) {
    String displayTitle = widget.title;
    if (widget.title == 'Row') displayTitle = 'Row Layout';

    return Scaffold(
      appBar: AppBar(title: Text(displayTitle)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildContent(widget.title),
        ),
      ),
    );
  }

  Widget _buildContent(String type) {
    switch (type) {
      case 'Text':
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
                    color: Colors.brown,
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
                TextSpan(text: '\nthe '),
                TextSpan(
                  text: 'lazy dog.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        );

      case 'Image':
        return Column(
          children: [
            // Ảnh 1: banner.jpg 
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/banner.jpg', // Đường dẫn assets
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Banner trường UTH (Local Asset)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Ảnh 2: logo.jpg (Phần In-app image)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/logo.jpg', 
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Logo UTH - In app', style: TextStyle(fontSize: 14)),
          ],
        );

      case 'TextField':
        return Column(
          children: [
            const SizedBox(height: 50),
            TextField(
              onChanged: (text) {
                setState(() {
                  _inputText = text;
                });
              },
              decoration: InputDecoration(
                hintText: 'Thông tin nhập',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tự động cập nhật dữ liệu theo textfield',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
            if (_inputText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _inputText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        );

      case 'PasswordField':
        return Column(
          children: [
            const SizedBox(height: 50),
            TextField(
              obscureText: true,
              onChanged: (text) {
                setState(() {
                  _inputText = text;
                });
              },
              decoration: InputDecoration(
                hintText: 'Nhập mật khẩu',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tự động cập nhật dữ liệu theo textfield',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
            if (_inputText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '•' * _inputText.length,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
          ],
        );

      // --- NỘI DUNG MỚI: CÁC LOẠI BUTTON, CHECKBOX, AUDIO UI ---
      case 'Button':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Các loại Button cơ bản
            const Text(
              "Buttons",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("Elevated")),
                OutlinedButton(onPressed: () {}, child: const Text("Outlined")),
                TextButton(onPressed: () {}, child: const Text("Text Button")),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                  label: const Text("Icon Btn"),
                ),
              ],
            ),
            const Divider(height: 40, thickness: 1),

            // 2. Checkbox & Switch
            const Text(
              "Selection Controls",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (val) => setState(() => _isChecked = val!),
                ),
                const Text("Checkbox"),
                const SizedBox(width: 20),
                Switch(
                  value: _isSwitched,
                  onChanged: (val) => setState(() => _isSwitched = val),
                ),
                const Text("Switch"),
              ],
            ),

            // 3. Radio Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: (val) => setState(() => _radioValue = val as int),
                ),
                const Text("Nam"),
                Radio(
                  value: 2,
                  groupValue: _radioValue,
                  onChanged: (val) => setState(() => _radioValue = val as int),
                ),
                const Text("Nữ"),
              ],
            ),
            const Divider(height: 40, thickness: 1),

            // 4. Audio Player UI Mockup
            const Text(
              "Audio Player UI",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.music_note, color: Colors.blue, size: 40),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Song Title Demo",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Artist Name",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("1:20", style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: _sliderValue,
                          onChanged: (val) =>
                              setState(() => _sliderValue = val),
                        ),
                      ),
                      const Text("4:30", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_previous),
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_next),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );

      case 'Row':
        return Column(
          children: [
            _buildRowOfBoxes(),
            const SizedBox(height: 15),
            _buildRowOfBoxes(),
            const SizedBox(height: 15),
            _buildRowOfBoxes(),
            const SizedBox(height: 15),
            _buildRowOfBoxes(),
          ],
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

  Widget _buildRowOfBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_blueBox(), _blueBox(), _blueBox()],
    );
  }

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
