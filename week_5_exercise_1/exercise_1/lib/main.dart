import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ---------------------------------------------------------
// 1. OOP: Tạo Class Model để quản lý dữ liệu (Data Model)
// ---------------------------------------------------------
class OnboardingModel {
  final String title;
  final String description;
  final IconData icon; // Dùng Icon thay cho ảnh thật để demo chạy ngay

  OnboardingModel({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTH SmartTasks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controller để điều khiển việc chuyển trang
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Dữ liệu cho các trang 2, 3, 4 (Trang 1 là Splash riêng)
  final List<OnboardingModel> _contents = [
    OnboardingModel(
      title: "Easy Time Management",
      description:
          "With management based on priority and daily tasks, it will give you convenience in managing and determining the tasks that must be done first.",
      icon: Icons.access_time_filled,
    ),
    OnboardingModel(
      title: "Increase Work Effectiveness",
      description:
          "Time management and the determination of more important tasks will give your job statistics better and always improve.",
      icon: Icons.bar_chart,
    ),
    OnboardingModel(
      title: "Reminder Notification",
      description:
          "The advantage of this application is that it also provides reminders for you so you don't forget to keep doing your assignments.",
      icon: Icons.notifications_active,
    ),
  ];

  // Hàm chuyển đến trang tiếp theo
  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Hàm quay lại trang trước
  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // -----------------------------------------------
            // PHẦN NỘI DUNG CHÍNH (PAGE VIEW)
            // -----------------------------------------------
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  // --- TRANG 1: Splash Screen ---
                  _buildSplashScreen(),

                  // --- TRANG 2, 3, 4: Nội dung Onboarding ---
                  // Sử dụng OOP data để sinh ra giao diện
                  for (var item in _contents) _buildOnboardingPage(item),
                ],
              ),
            ),

            // -----------------------------------------------
            // PHẦN ĐIỀU HƯỚNG (BUTTONS)
            // -----------------------------------------------
            Container(
              padding: const EdgeInsets.all(20),
              child: _buildBottomControl(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget: Thiết kế Trang 1 (Splash)
  Widget _buildSplashScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.school,
            size: 100,
            color: Colors.blue,
          ), // Logo giả lập
          const SizedBox(height: 20),
          const Text(
            "UTH",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00695C), // Màu xanh cổ vịt giống ảnh
            ),
          ),
          const Text(
            "University of Transport\nHo Chi Minh City",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            "UTH SmartTasks",
            style: TextStyle(
              fontSize: 24,
              color: Colors.blue.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          // Nút để bắt đầu từ trang 1 qua trang 2
          ElevatedButton(onPressed: _nextPage, child: const Text("Bắt đầu")),
        ],
      ),
    );
  }

  // Widget: Thiết kế Trang 2, 3, 4 (Template chung)
  Widget _buildOnboardingPage(OnboardingModel data) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Dots Indicator ở trên cùng (như ảnh)
          Row(
            children: List.generate(
              3, // 3 chấm cho 3 trang nội dung
              (index) => Container(
                margin: const EdgeInsets.only(right: 5),
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3), // Màu mặc định
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const Spacer(flex: 1),
          // Ảnh minh họa
          Icon(data.icon, size: 150, color: Colors.blueAccent),
          const Spacer(flex: 1),
          // Tiêu đề
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          // Mô tả
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  // Widget: Xử lý nút bấm bên dưới theo từng trang
  Widget _buildBottomControl() {
    // Trang 1 (Splash): Đã có nút ở giữa màn hình rồi, hoặc để trống
    if (_currentPage == 0) {
      return const SizedBox.shrink();
    }

    // Các trang nội dung (Index 1, 2, 3 tương ứng với Trang 2, 3, 4 trong yêu cầu)
    // Lưu ý: PageView index bắt đầu từ 0.
    // Index 0 = Trang 1 (Splash)
    // Index 1 = Trang 2
    // Index 2 = Trang 3
    // Index 3 = Trang 4

    bool isLastPage = _currentPage == 3;
    bool isFirstContentPage = _currentPage == 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Nút BACK (Mũi tên trái)
        // Hiện ở trang 3 và 4 (Index 2 và 3).
        // Yêu cầu "từ trang 4 trở về 3, 2, 1" -> Nút back cần hoạt động
        FloatingActionButton(
          onPressed: _previousPage,
          elevation: 0,
          backgroundColor: Colors.blue,
          mini: true,
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),

        // Nút NEXT hoặc GET STARTED
        SizedBox(
          width: 150,
          height: 45,
          child: ElevatedButton(
            onPressed: () {
              if (isLastPage) {
                // Xử lý khi nhấn Get Started (Ví dụ: vào màn hình chính)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Chuyển đến màn hình Home!")),
                );
              } else {
                _nextPage();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              isLastPage ? "Get Started" : "Next",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
