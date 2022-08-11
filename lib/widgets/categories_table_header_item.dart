import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:dosprav/providers/categories_provider.dart';
import 'package:dosprav/widgets/category_compose.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/models/task.dart';

class CategoriesTableHeaderItem extends StatelessWidget {
  const CategoriesTableHeaderItem({
    Key? key,
    required this.categoryId,
    this.isEditModeOn = false,
  }) : super(key: key);

  final String categoryId;
  final bool isEditModeOn;

  @override
  Widget build(BuildContext context) {
    var category = Provider.of<CategoriesProvider>(context, listen: true)
        .getById(categoryId);

    var tasksProvider = Provider.of<TasksProvider>(context, listen: false);

    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            height: 60,
            alignment: Alignment.center,
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Prompt",
                fontSize: 15,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (isEditModeOn && !category.isEditable)
            Positioned(
              right: 5,
              top: 15,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 15,
                child: IconButton(
                  constraints: BoxConstraints(),
                  iconSize: 30,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.do_not_touch_outlined,
                    size: 16,
                    color: Colors.white60,
                  ),
                  onPressed: null,
                ),
              ),
            ),
          if (isEditModeOn && category.isEditable)
            Positioned(
              right: 5,
              top: 5,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 10,
                child: IconButton(
                  constraints: BoxConstraints(),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  splashRadius: 10,
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => CategoryCompose(
                        categoryId: categoryId,
                      ),
                    );
                  },
                ),
              ),
            ),
          if (isEditModeOn && category.isEditable)
            Positioned(
              right: 5,
              bottom: 5,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 10,
                child: IconButton(
                  constraints: BoxConstraints(),
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  splashRadius: 10,
                  icon: Icon(
                    size: 19,
                    Icons.cancel,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () {
                    var categoryTasks =
                        tasksProvider.categorizedMap[category.id];

                    var contentText = "";
                    if (categoryTasks != null && categoryTasks.isNotEmpty) {
                      contentText =
                          "Do you want to delete the ${category.name} category? All its tasks will be moved to the Attic.";
                    } else {
                      contentText =
                          "Do you want to delete the ${category.name} category?";
                    }

                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Are you sure?"),
                        content: Text(contentText),
                        actions: [
                          TextButton(
                              child: Text("NO"),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              }),
                          TextButton(
                            child: Text("YES"),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              if (categoryTasks != null &&
                                  categoryTasks.isNotEmpty) {
                                for (var task in categoryTasks) {
                                  tasksProvider.updateTask(
                                    Task.fromTask(
                                      origin: task,
                                      categoryId: CategoriesProvider
                                          .tempAtticCategoryId,
                                    ),
                                  );
                                }
                              }
                              Provider.of<CategoriesProvider>(context,
                                      listen: false)
                                  .removeCategory(categoryId);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
