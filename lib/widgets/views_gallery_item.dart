import 'dart:math';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/view_models_provider.dart';
import 'package:dosprav/models/view_model.dart';

class ViewsGalleryItem extends StatelessWidget {
  const ViewsGalleryItem({
    Key? key,
    required this.viewModel,
    required this.viewScreenRouteName,
  }) : super(key: key);

  final ViewModel viewModel;
  final String viewScreenRouteName;

  @override
  Widget build(BuildContext context) {
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
              opacity: viewModel.isActivated ? 0.7 : 0.9,
              image: NetworkImage(viewModel.imageUrl),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              if (viewModel.isActivated) {
                Navigator.of(context)
                    .pushNamed(viewScreenRouteName, arguments: {
                  "viewModelId": viewModel.id,
                });
              } else {
                showDialog(
                  context: context,
                  builder: (ctx) => viewModel.createViewPreview(),
                ).then(
                  (value) {
                    if (value != null && value) {
                      Provider.of<ViewModelsProvider>(context, listen: false)
                          .updateViewModel(
                        ViewModel.fromViewModel(
                          origin: viewModel,
                          isActivated: true,
                        ),
                      );
                      Navigator.of(context)
                          .pushNamed(viewScreenRouteName, arguments: {
                        "viewModelId": viewModel.id,
                      });
                    }
                  },
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withAlpha(viewModel.isActivated ? 100 : 200),
              ),
              child: Stack(children: [
                Positioned(
                  top: 50,
                  left: 5,
                  child: Transform.rotate(
                    angle: -pi / 4,
                    child: Text(
                      viewModel.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 25,
                  bottom: 25,
                  child: Icon(
                    viewModel.isActivated ? Icons.check : Icons.cancel,
                    size: 45,
                    color: viewModel.isActivated
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
  }
}