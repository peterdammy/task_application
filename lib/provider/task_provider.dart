import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_app/model/task_model.dart';

import '../storage/task_storage.dart';

final taskListProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>((
  ref,
) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier() : super([]) {
    loadTasks();
  }

  final _storage = TaskStorage();

  Future<void> loadTasks() async {
    state = await _storage.loadTasks();
  }

  Future<void> addOrUpdateTask(TaskModel task) async {
    final existing = state.where((t) => t.taskId != task.taskId).toList();
    state = [...existing, task];
    await _storage.saveTasks(state);
  }

  Future<void> deleteTask(String id) async {
    state = state.where((t) => t.taskId != id).toList();
    await _storage.deleteTask(id);
  }

  Future<void> toggleFavorite(String id) async {
    state =
        state.map((task) {
          if (task.taskId == id) {
            return TaskModel(
              taskId: task.taskId,
              taskName: task.taskName,
              taskDescription: task.taskDescription,
              dueDate: task.dueDate,
              isCompleted: task.isCompleted,
              isFavorite: !task.isFavorite,
            );
          }
          return task;
        }).toList();
    await _storage.saveTasks(state);
  }
}
