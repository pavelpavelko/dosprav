import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:dosprav/providers/categories_provider.dart';
import 'package:dosprav/widgets/category_compose.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/models/task.dart';
import 'package:dosprav/models/home_slot.dart';
import 'package:dosprav/providers/home_slots_provider.dart';

class CategoriesTableHeaderItem extends StatelessWidget {
  const CategoriesTableHeaderItem({
    Key? key,
    required this.categoryId,
    this.isEditMode = false,
    this.isShortMode = false,
  }) : super(key: key);

  final String categoryId;
  final bool isEditMode;
  final bool isShortMode;

  @override
  Widget build(BuildContext context) {
    var category = Provider.of<CategoriesProvider>(context, listen: true)
        .getById(categoryId);
    var tasksProvider = Provider.of<TasksProvider>(context, listen: false);
    final homeSlotsProvider =
        Provider.of<HomeSlotsProvider>(context, listen: false);

    return Card(
      elevation: 3,
      color: Theme.of(context).colorScheme.secondary,
      margin: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 10),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            height: isShortMode ? 30 : 60,
            alignment: Alignment.center,
            child: Text(
              category.name,
              maxLines: isShortMode ? 1 : 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Prompt",
                fontSize: 15,
                overflow: TextOverflow.ellipsis,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (isEditMode && !category.isEditable)
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
          if (isEditMode)
            Positioned(
              left: 5,
              top: 15,
              child: CircleAvatar(
                backgroundColor: Colors.white60,
                radius: 15,
                child: IconButton(
                  constraints: BoxConstraints(),
                  iconSize: 30,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_circle_up,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    HomeSlot newSlot;
                    if (categoryId == CategoriesProvider.tempDailyCategoryId) {
                      newSlot = HomeSlot(slotType: SlotType.dailyList);
                    } else {
                      newSlot = HomeSlot(
                        slotType: SlotType.categoryView,
                        categoryId: categoryId,
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          homeSlotsProvider.getSnackBarMessage(
                              context, newSlot),
                        ),
                      ),
                    );
                    homeSlotsProvider.pushOnTop(newSlot);
                  },
                ),
              ),
            ),
          if (isEditMode && category.isEditable)
            Positioned(
              right: 5,
              top: 5,
              child: CircleAvatar(
                backgroundColor: Colors.white60,
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
          if (isEditMode && category.isEditable)
            Positioned(
              right: 5,
              bottom: 5,
              child: CircleAvatar(
                backgroundColor: Colors.white60,
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
                                  .removeCategory(categoryId)
                                  .onError((error, stackTrace) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Cannot delete category. Please try again later.",
                                      textAlign: TextAlign.center,
                                    ),
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                  ),
                                );
                              });
                              homeSlotsProvider.removeIfExist(categoryId);
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
