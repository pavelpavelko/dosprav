import 'package:dosprav/widgets/daily_view.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:dosprav/providers/view_models_provider.dart';
import 'package:dosprav/models/view_model.dart';

import 'package:dosprav/widgets/daily_view_tutorial.dart';

class ViewPreview extends StatefulWidget {
  const ViewPreview({Key? key, required this.viewModelId}) : super(key: key);

  final String viewModelId;

  @override
  _ViewPreviewState createState() => _ViewPreviewState();
}

class _ViewPreviewState extends State<ViewPreview> {
  bool isTutorialOn = false;

  Widget _createPreviewActivated(BuildContext context, ViewModel viewModel) {
    return Column(
      children: [
        Expanded(
          child: DailyView(),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Spacer(),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isTutorialOn = true;
                      });
                    },
                    child: Text("Tutorial"),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<ViewModelsProvider>(context, listen: false)
                          .updateViewModel(
                        ViewModel.fromViewModel(
                          origin: viewModel,
                          isActivated: false,
                        ),
                      );
                    },
                    child: Text(
                      "Postpone",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _createPreview(BuildContext context, ViewModel viewModel) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              DailyView(
                demoItems: DailyViewTutorial.getTutorialTasks(),
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withAlpha(180),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Positioned(
                child: Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: SingleChildScrollView(
                    child: Text(
                      viewModel.description,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Prompt",
                        color: Colors.white,
                      ),
                      //textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<ViewModelsProvider>(context, listen: false)
                          .updateViewModel(
                        ViewModel.fromViewModel(
                          origin: viewModel,
                          isActivated: true,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Text(
                      "Activate",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isTutorialOn = true;
                      });
                    },
                    child: Text("Tutorial"),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModelsProvider>(context, listen: true)
        .getViewModelById(widget.viewModelId);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: (isTutorialOn || !viewModel.isActivated) ? 105 : 55),
      backgroundColor: Color.fromARGB(0, 224, 175, 175),


      child: Center(
        child: Container(
//          curve: Curves.easeIn,
  //        duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
//          margin: EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          height: (isTutorialOn || !viewModel.isActivated) ? 450 : 550,
          padding: EdgeInsets.zero,
          child: isTutorialOn
              ? DailyViewTutorial(
                  onClose: (() => setState(
                        () {
                          isTutorialOn = false;
                        },
                      )),
                )
              : (viewModel.isActivated
                  ? _createPreviewActivated(context, viewModel)
                  : _createPreview(context, viewModel)),
        ),
      ),
    );
  }
}
