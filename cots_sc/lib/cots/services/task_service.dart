import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/task_model.dart';

class TaskService {
  // API Get Semua Tugas
  Future<List<Task>> getTasks() async {
    final url = Uri.parse('${AppConfig.baseUrl}/rest/v1/tasks?select=*&order=deadline.asc');
    
    final response = await http.get(url, headers: AppConfig.headers);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data tugas');
    }
  }

  // API Tambah Tugas
  Future<Task> addTask(Task task) async {
    final url = Uri.parse('${AppConfig.baseUrl}/rest/v1/tasks');
    
    final headers = {...AppConfig.headers, "Prefer": "return=representation"};

    final response = await http.post(
      url, 
      headers: headers,
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 201) {
      final List data = json.decode(response.body);
      return Task.fromJson(data.first);
    } else {
      throw Exception('Gagal menambah tugas');
    }
  }


  Future<void> updateStatus(int id, bool isDone) async {
    final url = Uri.parse('${AppConfig.baseUrl}/rest/v1/tasks?id=eq.$id');
    
    final String newStatus = isDone ? "SELESAI" : "BERJALAN";

    final body = {
      "is_done": isDone,
      "status": newStatus
    };

    final response = await http.patch(
      url,
      headers: AppConfig.headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Gagal update status');
    }
  }
}