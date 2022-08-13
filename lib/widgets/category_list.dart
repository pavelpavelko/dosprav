import 'package:dosprav/widgets/daily_view_list_item.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/models/task.dart';
import 'package:dosprav/widgets/categories_table_header_item.dart';
import 'package:dosprav/widgets/categories_table_item.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key? key,
    required this.categoryId,
    this.isCompleteVisible = false,
    this.isEditMode = false,
    this.isShortMode = false,
    this.isCarouselMode = false,
    this.isHeaderVisible = true,
    this.width,
  }) : super(key: key);

  final String categoryId;
  final bool isShortMode;
  final bool isCompleteVisible;
  final bool isEditMode;
  final bool isCarouselMode;
  final bool isHeaderVisible;
  final double? width;

  List<Task> _filterByCompleteness(List<Task> tasks) {
    List<Task> filteredTasks =
        tasks.where((task) => !task.isComplete || isCompleteVisible).toList();
    return filteredTasks;
  }

  Widget _taskProxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.all(1),
      color: Colors.white70,
      child: child,
    );
  }

  Widget _createItem(Task task) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isShortMode ? 15 : 20),
      ),
      key: UniqueKey(),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: isCarouselMode
            ? ClipRRect(
                borderRadius: BorderRadius.circular(isShortMode ? 15 : 20),
                child: DailyViewListItem(task: task, isShortMode: isShortMode),
              )
            : CategoriesTableItem(
                task: task,
                isShortMode: isShortMode,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var tasksProvider = Provider.of<TasksProvider>(context, listen: true);

    var categoryTasks = tasksProvider.categorizedMap[categoryId];

    var filteredTasks = _filterByCompleteness(categoryTasks ?? []);
    double columnWidth = width ?? double.infinity;
    
    return SizedBox(
      width: columnWidth,
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: ReorderableListView(
            proxyDecorator: _taskProxyDecorator,
            padding: EdgeInsets.all(5),
            header: isHeaderVisible
                ? CategoriesTableHeaderItem(
                    categoryId: categoryId,
                    isEditMode: isEditMode,
                    isShortMode: isShortMode,
                  )
                : null,
            children: <Widget>[
              for (var task in filteredTasks) _createItem(task),
            ],
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              tasksProvider.updateCategorizedOrderIndex(
                  categoryId, oldIndex, newIndex);
            }),
      ),
    );
  }
}
