class ViewModel {
  final String id;
  final String uid;
  final String name;
  final String imageUrl;
  final bool isActivated;
  final String description;

  ViewModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.imageUrl,
    this.isActivated = false,
    required this.description,
  });

  ViewModel.fromViewModel({
    required ViewModel origin,
    bool? isActivated,
  })  : id = origin.id,
        uid = origin.uid,
        name = origin.name,
        imageUrl = origin.imageUrl,
        description = origin.description,
        isActivated = isActivated ?? origin.isActivated;
}

