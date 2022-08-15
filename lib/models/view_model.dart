import 'package:flutter/material.dart';

class ViewModel {
  final String id;
  final String uid;
  final String name;
  final String imageUrl;
  final bool isActivated;
  final Widget Function() createViewPreview;
  final String viewScreenRouteName;

  ViewModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.imageUrl,
    this.isActivated = false,
    required this.createViewPreview,
    required this.viewScreenRouteName,
  });

  ViewModel.fromViewModel({
    required ViewModel origin,
    bool? isActivated,
  })  : id = origin.id,
        uid = origin.uid,
        name = origin.name,
        imageUrl = origin.imageUrl,
        createViewPreview = origin.createViewPreview,
        viewScreenRouteName = origin.viewScreenRouteName,
        isActivated = isActivated ?? origin.isActivated;
}
