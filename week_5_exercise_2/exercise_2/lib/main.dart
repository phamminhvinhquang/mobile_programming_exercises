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
      title: 'UTH SmartTasks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
      home: const ForgotPasswordScreen(),
    );
  }
}

// ==========================================
// MÀN 1: QUÊN MẬT KHẨU (NHẬP EMAIL)
// ==========================================
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CommonLogo(),
            const SizedBox(height: 30),
            const Text(
              "Forget Password?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter your Email, we will send you a verification code.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Your Email",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Chuyển sang màn 2, truyền Email
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VerifyCodeScreen(email: _emailController.text),
                  ),
                );
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// MÀN 2: XÁC THỰC MÃ (VERIFY CODE) - Đã sửa
// ==========================================
class VerifyCodeScreen extends StatefulWidget {
  final String email;
  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  // Tạo danh sách 5 controller để quản lý 5 ô nhập
  final List<TextEditingController> _controllers = List.generate(
    5,
    (index) => TextEditingController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CommonLogo(),
            const SizedBox(height: 30),
            const Text(
              "Verify Code",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter the code we just sent you on your registered Email",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Vẽ 5 ô nhập mã
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller:
                        _controllers[index], // Gán controller cho từng ô
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.zero,
                    ),
                    keyboardType: TextInputType.number,
                    // Tự động chuyển focus khi nhập 1 số (Tuỳ chọn thêm cho mượt)
                    onChanged: (value) {
                      if (value.length == 1 && index < 4) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // GỘP MÃ: Lấy text từ 5 ô ghép lại thành chuỗi
                String codeInput = _controllers.map((e) => e.text).join();

                // Chuyển sang màn 3, truyền Email VÀ Code đi tiếp
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePasswordScreen(
                      email: widget.email,
                      code: codeInput, // <--- Truyền mã vừa nhập sang màn sau
                    ),
                  ),
                );
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// MÀN 3: TẠO MẬT KHẨU MỚI - Đã sửa
// ==========================================
class CreatePasswordScreen extends StatefulWidget {
  final String email;
  final String code; // Nhận thêm biến code từ màn trước

  const CreatePasswordScreen({
    super.key,
    required this.email,
    required this.code, // <---
  });

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CommonLogo(),
            const SizedBox(height: 30),
            const Text(
              "Create new password",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your new password must be different form previously used password",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPassController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Confirm Password",
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Chuyển sang màn 4
                // Truyền đủ 3 món: Email, Password, và Code
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmScreen(
                      email: widget.email,
                      password: _passController.text,
                      code: widget.code, // <--- Truyền code tiếp sang màn cuối
                    ),
                  ),
                );
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// MÀN 4: XÁC NHẬN - Đã sửa
// ==========================================
class ConfirmScreen extends StatefulWidget {
  final String email;
  final String password;
  final String code; // Nhận biến code

  const ConfirmScreen({
    super.key,
    required this.email,
    required this.password,
    required this.code, // <---
  });

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  // Controller để hiển thị dữ liệu
  late TextEditingController _emailController;
  late TextEditingController _passController;
  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    // TỰ ĐỘNG ĐIỀN: Lấy dữ liệu được truyền tới
    _emailController = TextEditingController(text: widget.email);
    _passController = TextEditingController(text: widget.password);
    _codeController = TextEditingController(
      text: widget.code,
    ); // <--- Lấy mã code thực tế
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CommonLogo(),
            const SizedBox(height: 30),
            const Text(
              "Confirm",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "We are here to help you!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Ô Email
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),

            // Ô Mã (Đã sửa để hiển thị mã thực tế)
            TextField(
              controller: _codeController,
              readOnly: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.check_circle_outline),
              ),
            ),
            const SizedBox(height: 16),

            // Ô Password
            TextField(
              controller: _passController,
              readOnly: true,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                // QUAY VỀ MÀN HÌNH ĐẦU TIÊN
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Logo & Tiêu đề dùng chung
class CommonLogo extends StatelessWidget {
  const CommonLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Icon(Icons.school, size: 60, color: Colors.teal),
        SizedBox(height: 8),
        Text(
          "UTH",
          style: TextStyle(
            color: Colors.teal,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        Text(
          "UNIVERSITY\nOF TRANSPORT\nHOCHIMINH CITY",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "SmartTasks",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
