import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/view_models_provider.dart';
import 'package:dosprav/widgets/views_gallery_item.dart';

class ViewsGallery extends StatefulWidget {
  const ViewsGallery({Key? key}) : super(key: key);

  @override
  State<ViewsGallery> createState() => _ViewsGalleryState();
}

class _ViewsGalleryState extends State<ViewsGallery> {
  @override
  void initState() {
    super.initState();
    _fetchViewModelActiveStatuses();
  }

  Future<void> _fetchViewModelActiveStatuses() async {
    try {
      await Provider.of<ViewModelsProvider>(context, listen: false)
          .fetchViewModelStatuses();
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cannot download Views active statuses. Please try again later.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final views = Provider.of<ViewModelsProvider>(context).items;

    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: EdgeInsets.all(15),
      children: views.map((viewModel) {
        return ViewsGalleryItem(
          viewModel: viewModel,
          viewScreenRouteName: viewModel.viewScreenRouteName,
        );
      }).toList(),
    );
  }
}
