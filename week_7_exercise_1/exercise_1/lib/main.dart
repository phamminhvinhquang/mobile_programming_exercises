import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const SmartTasksApp());
}

class SmartTasksApp extends StatelessWidget {
  const SmartTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTH SmartTasks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// --- Model ---
class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final String dueDate;
  final String priority; // Thêm trường này
  final String category; // Thêm trường này

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDate,
    required this.priority,
    required this.category,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Pending',
      dueDate: json['dueDate'] ?? '',
      priority: json['priority'] ?? 'Medium', // Lấy từ JSON
      category: json['category'] ?? 'General', // Lấy từ JSON
    );
  }
}

// --- Màn hình chính (Danh sách) ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = fetchTasks();
  }

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(
      Uri.parse('https://amock.io/api/researchUTH/tasks'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Truy cập vào key 'data' để lấy List công việc
      final List<dynamic> taskData = jsonResponse['data'];

      return taskData.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "UTH SmartTasks",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyView();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final task = snapshot.data![index];
              return _buildTaskCard(task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.assignment_late_outlined,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            "No Tasks Yet!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Stay productive - add something to do",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    // Logic đổi màu dựa trên trạng thái
    Color cardColor = Colors.white;
    if (task.status == 'In Progress') cardColor = Colors.red.shade50;
    if (task.status == 'Pending') cardColor = Colors.green.shade50;
    if (task.status == 'Completed') cardColor = Colors.blue.shade50;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              "Status: ${task.status} | ${task.dueDate}",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(taskId: task.id),
            ),
          ).then(
            (_) => setState(() {
              futureTasks = fetchTasks();
            }),
          );
        },
      ),
    );
  }
}

// --- Màn hình Chi tiết ---
class DetailScreen extends StatelessWidget {
  final String taskId;
  const DetailScreen({super.key, required this.taskId});

  Future<Task> fetchTaskDetail() async {
    final response = await http.get(
      Uri.parse('https://amock.io/api/researchUTH/task/$taskId'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Truy cập vào jsonResponse['data'] thay vì toàn bộ body
      return Task.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to load detail');
    }
  }

  Future<void> deleteTask(BuildContext context) async {
    final response = await http.delete(
      Uri.parse('https://amock.io/api/researchUTH/task/$taskId'),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Deleted successfully")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => deleteTask(context),
          ),
        ],
      ),
      body: FutureBuilder<Task>(
        future: fetchTaskDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Center(child: Text("No data"));

          final task = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(task.description),
                const Divider(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoChip(
                      "Category",
                      task.category,
                      Colors.red.shade100,
                    ), // Dùng dữ liệu thật
                    _infoChip("Status", task.status, Colors.blue.shade100),
                    _infoChip(
                      "Priority",
                      task.priority,
                      Colors.orange.shade100,
                    ), // Dùng dữ liệu thật
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
