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
              image: AssetImage(viewModel.imageAssetPath),
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
                          .updateViewModelActiveStatus(
                        viewModel.id,
                        true,
                      )
                          .onError((error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Cannot activate view. Please try again later.",
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Theme.of(context).errorColor,
                          ),
                        );
                      });
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
                  top: 45,
                  left: 10,
                  child: Transform.rotate(
                    angle: -pi / 4,
                    child: Text(
                      viewModel.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 5,
                  child: Column(
                    children: [
                      Icon(
                        viewModel.isActivated ? Icons.check : Icons.cancel_outlined,
                        size: 45,
                        color: viewModel.isActivated
                            ? Theme.of(context).colorScheme.primary
                            : Colors.blueGrey,
                      ),
                      Text(
                        viewModel.isActivated ? "Activated" : "Try it now!",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: viewModel.isActivated
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
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
