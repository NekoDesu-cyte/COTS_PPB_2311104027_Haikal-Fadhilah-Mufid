import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskController extends ChangeNotifier {
  final TaskService _service = TaskService();
  
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Getter statistik
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.isDone).length;

  // Fungsi untuk Load Data dari API
  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _service.getTasks();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Error fetching tasks: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi Tambah Tugas
  Future<void> addTask(Task task) async {
    try {
      // Kirim ke API
      await _service.addTask(task);
      await fetchTasks();
    } catch (e) {
      debugPrint("Error adding task: $e");
      rethrow; 
    }
  }

  // Fungsi Update Status
  Future<void> toggleTaskStatus(int id) async { 
    try {
      final taskIndex = _tasks.indexWhere((t) => t.id == id);
      if (taskIndex != -1) {
        final currentStatus = _tasks[taskIndex].isDone;
        final newStatus = !currentStatus;

        _tasks[taskIndex].isDone = newStatus;
        notifyListeners();

        await _service.updateStatus(id, newStatus);
        
        await fetchTasks(); 
      }
    } catch (e) {
      debugPrint("Error updating status: $e");
      await fetchTasks(); 
    }
  }
}