import 'category.dart';

class Task implements Comparable {
  final String id;
  final String uid;
  final String name;
  final String description;
  final DateTime timestampCreated;
  final DateTime dueDate;
  final Duration intervalDuration;
  final bool isComplete;
  final Category category;

  Task({
    required this.id,
    required this.uid,
    required this.name,
    required this.description,
    required this.timestampCreated,
    required this.dueDate,
    this.isComplete = false,
    required this.category,
    required this.intervalDuration,
  });

  Task.fromTask({
    required Task origin,
    String? name,
    String? description,
    bool? isComplete,
    Category? category,
    DateTime? dueDate,
    Duration? intervalDuration,
  })  : id = origin.id,
        uid = origin.uid,
        timestampCreated = origin.timestampCreated,
        name = name ?? origin.name,
        description = description ?? origin.description,
        category = category ?? origin.category,
        isComplete = isComplete ?? origin.isComplete,
        dueDate = dueDate ?? origin.dueDate,
        intervalDuration = intervalDuration ?? origin.intervalDuration;

  @override
  int compareTo(other) {
    int result = _completenessComparator(this, other);
    result = result == 0 ? _timestampComparator(this, other) : result;
    return result;
  }

  int _completenessComparator(left, right) {
    if (left.isComplete == right.isComplete) return 0;
    return !right.isComplete ? 1 : -1;
  }

  int _timestampComparator(left, right) {
    return left.timestampCreated.compareTo(right.timestampCreated);
  }
}