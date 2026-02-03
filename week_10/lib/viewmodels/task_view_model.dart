import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../data/database_helper.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await _dbHelper.getTasks();
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    final newTask = Task(title: title, description: description);
    await _dbHelper.insertTask(newTask);
    await loadTasks();
  }
}
