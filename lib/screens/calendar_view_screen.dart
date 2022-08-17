import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/view_models_provider.dart';
import 'package:dosprav/models/view_model.dart';
import 'package:dosprav/widgets/create_task_sheet.dart';
import 'package:dosprav/widgets/calendar_view.dart';

class CalendarViewScreen extends StatelessWidget {
  const CalendarViewScreen({Key? key}) : super(key: key);

  static const String routeName = "/calendar-view";

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final viewModelId = routeArgs["viewModelId"];
    assert(viewModelId != null);

    final viewModelsProvider =
        Provider.of<ViewModelsProvider>(context, listen: false);
    final viewModel = viewModelsProvider.getViewModelById(viewModelId!);

    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String item) {
              switch (item) {
                case "Postpone":
                  viewModelsProvider.updateViewModel(
                    ViewModel.fromViewModel(
                      origin: viewModel,
                      isActivated: false,
                    ),
                  );
                  Navigator.of(context).pop();
                  break;
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: "Postpone",
                child: Text("Postpone"),
              ),
            ],
          ),
        ],
      ),
      body: CreateTaskSheet(
        sheetTopBarColor: Theme.of(context).colorScheme.primary,
        actionButtonFrameColor: Theme.of(context).colorScheme.secondary,
        actionButtonColor: Theme.of(context).colorScheme.primary,
        actionButtonSize: 60,
        child: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: CalendarView(),
        ),
      ),
    );
  }
}
