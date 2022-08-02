import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/view_models_provider.dart';
import 'package:dosprav/screens/daily_view_screen.dart';
import 'package:dosprav/widgets/views_gallery_item.dart';

class ViewsGallery extends StatelessWidget {
  const ViewsGallery({Key? key}) : super(key: key);

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
          viewScreenRouteName: DailyViewScreen.routeName,
        );
      }).toList(),
    );
  }
}
