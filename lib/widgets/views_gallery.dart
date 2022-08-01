import 'dart:math';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/view_models_provider.dart';
import 'package:dosprav/widgets/view_preview.dart';

class ViewsGallery extends StatefulWidget {
  const ViewsGallery({Key? key}) : super(key: key);

  @override
  _ViewsGalleryState createState() => _ViewsGalleryState();
}

class _ViewsGalleryState extends State<ViewsGallery> {
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
      children: views.map((view) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  opacity: view.isActivated ? 0.7 : 0.9,
                  image: NetworkImage(view.imageUrl),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => ViewPreview(viewModelId: view.id),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withAlpha(view.isActivated ? 100 : 200),
                  ),
                  child: Stack(children: [
                    Positioned(
                      top: 50,
                      left: 5,
                      child: Transform.rotate(
                        angle: -pi / 4,
                        child: Text(
                          view.name,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            //color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 25,
                      bottom: 25,
                      child: Icon(
                        view.isActivated ? Icons.check : Icons.cancel,
                        size: 45,
                        color: view.isActivated
                            ? Theme.of(context).colorScheme.primary
                            : Colors.blueGrey,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
