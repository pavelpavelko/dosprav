
class Category {
  final String id;
  final String uid;
  final String name;
  final bool isActive;

  Category({
    required this.id,
    required this.uid,
    required this.name,
    this.isActive = false,
  });
}
