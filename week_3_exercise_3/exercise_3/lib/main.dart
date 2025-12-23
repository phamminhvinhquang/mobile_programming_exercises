import 'package:flutter/material.dart';

void main() {
  // Điểm khởi đầu của ứng dụng: Khởi chạy widget gốc LibraryApp
  runApp(const LibraryApp());
}

/// Lớp chính cấu hình ứng dụng (Root Widget)
class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Ẩn biểu tượng Debug ở góc màn hình
      title: 'Hệ thống Quản lý Thư viện',
      theme: ThemeData(
        // Thiết lập bảng màu chủ đạo (Seed Color) và Material 3
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Chỉ định trang mặc định khi mở app
      home: const LibraryHomePage(),
    );
  }
}

// ---------------------------------------------------------
// 1. MODELS - Định nghĩa cấu trúc dữ liệu (OOP)
// ---------------------------------------------------------

/// Lớp dữ liệu cho Sách
class Book {
  String title; // Tên cuốn sách
  bool isBorrowed; // Trạng thái: true (đã có người mượn), false (còn trong kho)

  Book({required this.title, this.isBorrowed = false});
}

/// Lớp dữ liệu cho Thành viên/Nhân viên
class Staff {
  String name; // Tên thành viên
  String position; // Chức vụ
  List<Book>
  borrowedBooks; // Danh sách các cuốn sách cụ thể mà người này đang giữ

  Staff({required this.name, required this.position, List<Book>? borrowedBooks})
    : borrowedBooks =
          borrowedBooks ?? []; // Nếu không truyền danh sách, khởi tạo list rỗng
}

// ---------------------------------------------------------
// 2. UI & LOGIC - Trang chủ quản lý trạng thái
// ---------------------------------------------------------

class LibraryHomePage extends StatefulWidget {
  const LibraryHomePage({super.key});

  @override
  State<LibraryHomePage> createState() => _LibraryHomePageState();
}

class _LibraryHomePageState extends State<LibraryHomePage> {
  // Controller để lấy văn bản từ TextField khi nhập tên thành viên
  final TextEditingController _newNameController = TextEditingController();

  // Dữ liệu State (Trạng thái) của ứng dụng
  List<Book> books = []; // Danh sách tất cả sách trong hệ thống
  List<Staff> staffs = []; // Danh sách tất cả thành viên đã đăng ký
  int _selectedIndex = 0; // Lưu vị trí tab đang chọn (0, 1, hoặc 2)

  // Biến tạm lưu trữ đối tượng được chọn từ các menu thả xuống (Dropdown)
  Book? _selectedBookToAssign;
  Staff? _selectedStaffToAssign;

  // --- CÁC HÀM XỬ LÝ LOGIC (LOGIC FUNCTIONS) ---

  /// Thêm một cuốn sách mới vào kho dữ liệu
  void _addBook() {
    setState(() {
      // Tạo sách mới với tên tự động "Sách + số thứ tự"
      books.add(Book(title: "Sách ${books.length + 1}"));
    });
  }

  /// Đăng ký một thành viên mới
  void _addStaff() {
    if (_newNameController.text.isNotEmpty) {
      setState(() {
        staffs.add(
          Staff(name: _newNameController.text, position: "Khách hàng"),
        );
        _newNameController.clear(); // Xóa chữ trong ô nhập sau khi thêm xong
      });
    }
  }

  /// Thực hiện quy trình cho mượn sách
  void _assignBookToStaff() {
    // 1. Kiểm tra điều kiện đầu vào
    if (_selectedStaffToAssign == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vui lòng chọn người mượn")));
      return;
    }
    if (_selectedBookToAssign == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vui lòng chọn sách")));
      return;
    }

    // 2. Cập nhật dữ liệu
    setState(() {
      // Thêm cuốn sách đã chọn vào danh sách của thành viên đó
      _selectedStaffToAssign!.borrowedBooks.add(_selectedBookToAssign!);
      // Đánh dấu cuốn sách này là "Đã mượn" để không hiện ở chỗ khác nữa
      _selectedBookToAssign!.isBorrowed = true;
      // Reset dropdown chọn sách về rỗng
      _selectedBookToAssign = null;
    });
  }

  // --- CÁC THÀNH PHẦN GIAO DIỆN CON (SUB-WIDGETS) ---

  /// Widget hiển thị danh sách sách dưới dạng List
  Widget _buildCommonBookList() {
    if (books.isEmpty) {
      return const Center(child: Text("Chưa có sách nào trong thư viện"));
    }
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return Card(
          child: CheckboxListTile(
            title: Text(books[index].title),
            subtitle: Text(books[index].isBorrowed ? "Đã mượn" : "Sẵn có"),
            value: books[index].isBorrowed,
            onChanged: (bool? value) {
              setState(() {
                books[index].isBorrowed = value ?? false;
              });
            },
          ),
        );
      },
    );
  }

  /// TAB 1: GIAO DIỆN QUẢN LÝ (Mượn/Trả sách)
  Widget _buildManagementPage() {
    // Chỉ lấy ra những cuốn sách hiện đang rảnh (isBorrowed == false)
    List<Book> availableBooks = books.where((b) => !b.isBorrowed).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Chọn người mượn sách",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Dropdown chọn người mượn
        DropdownButtonFormField<Staff>(
          value: _selectedStaffToAssign,
          hint: const Text("Chọn tên"),
          items: staffs.map((Staff staff) {
            return DropdownMenuItem<Staff>(
              value: staff,
              child: Text(staff.name),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedStaffToAssign = value),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Chọn sách mượn",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              // Dropdown chọn sách từ danh sách sách sẵn có
              child: DropdownButtonFormField<Book>(
                value: _selectedBookToAssign,
                hint: const Text("Chọn sách"),
                items: availableBooks.map((Book book) {
                  return DropdownMenuItem<Book>(
                    value: book,
                    child: Text(book.title),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedBookToAssign = value),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _assignBookToStaff,
              child: const Text("Xác nhận mượn"),
            ),
          ],
        ),
        const Divider(height: 40),
        // Hiển thị kết quả: Những sách mà người đang chọn đã mượn
        Text(
          _selectedStaffToAssign == null
              ? "Chi tiết mượn sách"
              : "Sách của: ${_selectedStaffToAssign!.name}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Expanded(
          child:
              _selectedStaffToAssign == null ||
                  _selectedStaffToAssign!.borrowedBooks.isEmpty
              ? const Center(child: Text("Không có dữ liệu"))
              : ListView.builder(
                  itemCount: _selectedStaffToAssign!.borrowedBooks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(
                        _selectedStaffToAssign!.borrowedBooks[index].title,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// TAB 2: GIAO DIỆN DANH SÁCH SÁCH (Kho sách tổng)
  Widget _buildBookListPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kho sách tổng quát",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(child: _buildCommonBookList()),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton.icon(
            onPressed: _addBook,
            icon: const Icon(Icons.add),
            label: const Text("Thêm sách mới"),
            style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
          ),
        ),
      ],
    );
  }

  /// TAB 3: GIAO DIỆN THÀNH VIÊN (Quản lý con người)
  Widget _buildStaffListPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Đăng ký thành viên mới",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newNameController,
                decoration: const InputDecoration(
                  labelText: "Họ và tên",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(onPressed: _addStaff, child: const Text("Thêm")),
          ],
        ),
        const Divider(height: 30),
        Expanded(
          child: staffs.isEmpty
              ? const Center(child: Text("Chưa có thành viên nào"))
              : ListView.builder(
                  itemCount: staffs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(staffs[index].name),
                        subtitle: Text(
                          "Đã mượn: ${staffs[index].borrowedBooks.length} sách",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              // Nếu xóa người đang được xem ở Tab Quản lý, hãy reset biến tạm
                              if (_selectedStaffToAssign == staffs[index]) {
                                _selectedStaffToAssign = null;
                              }
                              staffs.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Biến tạm để quyết định nội dung nào sẽ hiển thị trên màn hình
    Widget bodyContent;
    switch (_selectedIndex) {
      case 1:
        bodyContent = _buildBookListPage();
        break;
      case 2:
        bodyContent = _buildStaffListPage();
        break;
      default:
        bodyContent = _buildManagementPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Thư viện'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Hiển thị nội dung tương ứng với Tab đã chọn
      body: Padding(padding: const EdgeInsets.all(16.0), child: bodyContent),

      // Thanh điều hướng dưới cùng giúp chuyển đổi giữa 3 màn hình
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Mục nào đang sáng
        onTap: (index) => setState(() => _selectedIndex = index), // Hàm đổi Tab
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Quản lý'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'DS Sách'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Thành viên',
          ),
        ],
      ),
    );
  }
}
