import 'package:dosprav/widgets/categories_table_item.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/models/task.dart';
import 'package:dosprav/providers/categories_provider.dart';
import 'package:dosprav/models/category.dart';

class CategoriesTableView extends StatefulWidget {
  const CategoriesTableView({
    Key? key,
    this.isCompletedVisible = false,
    this.isCarouselModeOn = false,
    this.isEditModeOn = false,
  }) : super(key: key);

  final bool isCompletedVisible;
  final bool isCarouselModeOn;
  final bool isEditModeOn;

  @override
  _CategoriesTableViewState createState() => _CategoriesTableViewState();
}

class _CategoriesTableViewState extends State<CategoriesTableView> {
  final double _cellSize = 50;

  bool _isCompletedVisible = false;
  bool _isCarouselModeOn = false;
  bool _isEditModeOn = false;

  @override
  void initState() {
    super.initState();
    _isCompletedVisible = widget.isCompletedVisible;
    _isCarouselModeOn = widget.isCarouselModeOn;
    _isEditModeOn = widget.isEditModeOn;
  }

  List<Task> filterByCompleteness(List<Task> tasks) {
    List<Task> filteredTasks =
        tasks.where((task) => !task.isComplete || _isCompletedVisible).toList();
    return filteredTasks;
  }

  Widget _createCategoryColumn(
      BuildContext context, Category category, List<Task> tasks) {
    var tasksProvider = Provider.of<TasksProvider>(context, listen: true);

    var filteredTasks = filterByCompleteness(tasks);
    return Container(
      key: UniqueKey(),
      width: 140,
      margin: EdgeInsets.all(3),
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: ReorderableListView(
          proxyDecorator: _taskProxyDecorator,
          padding: EdgeInsets.all(5),
          header: _createColumnHeader(category),
          children: <Widget>[
            for (var task in filteredTasks) _createTableItem(task),
          ],
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              tasksProvider.updateCategorizedOrderIndex(
                  category.id, oldIndex, newIndex);
            });
          },
        ),
      ),
    );
  }

  Widget _columnProxyDecorator(
      Widget child, int index, Animation<double> animation) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(1),
      child: child,
    );
  }

  Widget _taskProxyDecorator(
      Widget child, int index, Animation<double> animation) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.all(1),
      color: Colors.white70,
      child: child,
    );
  }

  Widget _createTableItem(Task task) {
    return Card(
      key: UniqueKey(),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: CategoriesTableItem(
          task: task,
        ),
      ),
    );
  }

  Widget _createColumnHeader(Category category) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: Container(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: true);
    var categorizedMap =
        Provider.of<TasksProvider>(context, listen: true).categorizedMap;
    var categories = categoriesProvider.itemsSorted;

    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(160),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: _isCompletedVisible
                            ? BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 25,
                          icon: Icon(
                            _isCompletedVisible
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isCompletedVisible = !_isCompletedVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: _isCarouselModeOn
                            ? BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: IconButton(
                          iconSize: 25,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            _isCarouselModeOn
                                ? Icons.view_carousel_rounded
                                : Icons.view_carousel_outlined,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isCarouselModeOn = !_isCarouselModeOn;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: _isEditModeOn
                            ? BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: IconButton(
                          iconSize: 25,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            _isEditModeOn
                                ? Icons.edit_rounded
                                : Icons.edit_outlined,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isEditModeOn = !_isEditModeOn;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ReorderableListView(
                scrollDirection: Axis.horizontal,
                proxyDecorator: _columnProxyDecorator,
                children: <Widget>[
                  for (var category in categories)
                    _createCategoryColumn(
                      context,
                      category,
                      categorizedMap[category.id] != null
                          ? categorizedMap[category.id]!
                          : [],
                    ),
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    categoriesProvider.updateOrderIndex(oldIndex, newIndex);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
