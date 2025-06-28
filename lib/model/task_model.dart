// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaskModel {
  final String taskId;
  final String taskName;
  final String taskDescription;
  bool isCompleted;
  bool isFavorite;
  final DateTime dueDate;

  TaskModel({
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.dueDate,
    this.isCompleted = false,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'isCompleted': isCompleted,
      'isFavorite': isFavorite,
      'dueDate': dueDate.millisecondsSinceEpoch,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'] as String,
      taskName: map['taskName'] as String,
      taskDescription: map['taskDescription'] as String,
      isCompleted: map['isCompleted'] as bool,
      isFavorite: map['isFavorite'] as bool,
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
