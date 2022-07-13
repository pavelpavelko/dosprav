import 'category.dart';

class Task {
  final String id;
  final String uid;
  final String name;
  final String description;
  final TaskType taskType;
  final DateTime timestampCreated;
  final bool isComplete;
  final Category category;

  Task({
    required this.id,
    required this.uid,
    required this.name,
    required this.description,
    required this.taskType,
    required this.timestampCreated,
    this.isComplete = false,
    required this.category,
  });
}

enum TaskType {
  disposable,
  goalTrack,
}
