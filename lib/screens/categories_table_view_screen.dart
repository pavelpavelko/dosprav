import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/view_models_provider.dart';
import 'package:dosprav/models/view_model.dart';
import 'package:dosprav/widgets/create_task_sheet.dart';
import 'package:dosprav/widgets/categories_table_view.dart';
import 'package:dosprav/widgets/category_compose.dart';

class CategoriesTableViewScreen extends StatefulWidget {
  static const String routeName = "/categories-table-view";

  const CategoriesTableViewScreen({Key? key}) : super(key: key);

  @override
  _CategoriesTableViewScreenState createState() =>
      _CategoriesTableViewScreenState();
}

class _CategoriesTableViewScreenState extends State<CategoriesTableViewScreen> {
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
        title: Text("Categories Table"),
        actions: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
            radius: 12,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => CategoryCompose(),
                );
              },
              icon: Icon(
                Icons.add_circle_outlined,
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ),
            ),
          ),
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
                case "Create":
                  showDialog(
                    context: context,
                    builder: (ctx) => CategoryCompose(),
                  );
                  break;
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: "Postpone",
                child: Text("Postpone"),
              ),
              PopupMenuItem<String>(
                value: "Create",
                child: Text("Create"),
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
          child: CategoriesTableView(),
        ),
      ),
    );
  }
}
