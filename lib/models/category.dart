class Category implements Comparable {
  final String id;
  final String uid;
  final String name;
  final bool isActive;
  final int priorityOrder;

  Category({
    required this.id,
    required this.uid,
    required this.name,
    this.isActive = false,
    required this.priorityOrder,
  });

  Category.fromCategory({
    required Category origin,
    String? name,
    bool? isActive,
    int? priorityOrder,
  })  : id = origin.id,
        uid = origin.uid,
        name = name ?? origin.name,
        isActive = isActive ?? origin.isActive,
        priorityOrder = priorityOrder ?? origin.priorityOrder;

  @override
  String toString() {
    return name;
  }

  @override
  int compareTo(other) {
    int result = _priorityOrderComparator(this, other);
    result = result == 0 ? _nameComparator(this, other) : result;
    return result;
  }

  int _priorityOrderComparator(Category left, Category right) {
    if (left.priorityOrder == right.priorityOrder) return 0;
    return left.priorityOrder > right.priorityOrder ? 1 : -1;
  }

  int _nameComparator(Category left, Category right) {
    return left.name.compareTo(right.name);
  }
}
