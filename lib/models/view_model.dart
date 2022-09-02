import 'package:flutter/material.dart';

class ViewModel {
  final String id;
  final String name;
  final String imageAssetPath;
  final bool isActivated;
  final Widget Function() createViewPreview;
  final String viewScreenRouteName;


  ViewModel({
    required this.id,
    required this.name,
    required this.imageAssetPath,
    this.isActivated = false,
    required this.createViewPreview,
    required this.viewScreenRouteName,
  });

  ViewModel.fromViewModel({
    required ViewModel origin,
    String? id,
    String? name,
    String? imageAssetPath,
    bool? isActivated,
  })  : id = id ?? origin.id,
        name = name ?? origin.name,
        imageAssetPath = imageAssetPath ?? origin.imageAssetPath,
        createViewPreview = origin.createViewPreview,
        viewScreenRouteName = origin.viewScreenRouteName,
        isActivated = isActivated ?? origin.isActivated;
}
