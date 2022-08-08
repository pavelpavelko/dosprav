class Task implements Comparable {
  final String id;
  final String uid;
  final String name;
  final String description;
  final DateTime timestampCreated;
  final DateTime dueDate;
  final Duration intervalDuration;
  final bool isComplete;
  final String categoryId;
  final double priorityOrder;

  Task({
    required this.id,
    required this.uid,
    required this.name,
    required this.description,
    required this.timestampCreated,
    required this.dueDate,
    this.isComplete = false,
    required this.categoryId,
    required this.intervalDuration,
    this.priorityOrder = double.infinity,
  });

  Task.fromTask({
    required Task origin,
    String? name,
    String? description,
    bool? isComplete,
    String? categoryId,
    DateTime? dueDate,
    Duration? intervalDuration,
    double? priorityOrder,
  })  : id = origin.id,
        uid = origin.uid,
        timestampCreated = origin.timestampCreated,
        name = name ?? origin.name,
        description = description ?? origin.description,
        categoryId = categoryId ?? origin.categoryId,
        isComplete = isComplete ?? origin.isComplete,
        dueDate = dueDate ?? origin.dueDate,
        priorityOrder = priorityOrder ?? origin.priorityOrder,
        intervalDuration = intervalDuration ?? origin.intervalDuration;

  @override
  int compareTo(other) {
    int result = _completenessComparator(this, other);
    result = result == 0 ? _priorityOrderComparator(this, other) : result;
    result = result == 0 ? _timestampComparator(this, other) : result;
    return result;
  }

  int _priorityOrderComparator(left, right) {
    if (left.priorityOrder == right.priorityOrder) return 0;
    return left.priorityOrder > right.priorityOrder ? 1 : -1;
  }

  int _completenessComparator(left, right) {
    if (left.isComplete == right.isComplete) return 0;
    return !right.isComplete ? 1 : -1;
  }

  int _timestampComparator(left, right) {
    return left.timestampCreated.compareTo(right.timestampCreated);
  }
}
