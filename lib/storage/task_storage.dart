import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/model/task_model.dart';

class TaskStorage {
  static const String _taskMapKey = 'tasks_map';

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final map = {for (var task in tasks) task.taskId: jsonEncode(task.toMap())};
    await prefs.setString(_taskMapKey, jsonEncode(map));
  }

  Future<List<TaskModel>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_taskMapKey);
    if (jsonString == null) return [];

    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    return decoded.values.map((e) => TaskModel.fromMap(jsonDecode(e))).toList();
  }

  Future<void> deleteTask(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_taskMapKey);
    if (jsonString == null) return;

    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    decoded.remove(taskId);
    await prefs.setString(_taskMapKey, jsonEncode(decoded));
  }
}
