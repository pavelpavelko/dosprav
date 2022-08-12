import 'package:dosprav/widgets/categories_table_item.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/models/task.dart';
import 'package:dosprav/providers/categories_provider.dart';
import 'package:dosprav/models/category.dart';
import 'package:dosprav/widgets/categories_table_header_item.dart';
import 'package:dosprav/widgets/daily_view_list_item.dart';

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
  bool _isCompletedVisible = false;
  bool _isCarouselModeOn = false;
  bool _isEditModeOn = false;

  final CarouselController _carouselController = CarouselController();

  int _carouselCurrentPage = 0;

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
    BuildContext context,
    Category category,
    List<Task> tasks,
  ) {
    var tasksProvider = Provider.of<TasksProvider>(context, listen: true);
    var categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);

    var filteredTasks = filterByCompleteness(tasks);
    double columnWidth;
    double approxPaddingSum = 30;
    if (_isCarouselModeOn) {
      columnWidth = double.infinity;
    } else {
      if (categoriesProvider.items.length == 2) {
        columnWidth =
            (MediaQuery.of(context).size.width - approxPaddingSum) / 2;
      } else {
        columnWidth =
            (MediaQuery.of(context).size.width - approxPaddingSum) / 2.5;
      }
    }

    // ignore: sized_box_for_whitespace
    return Container(
      key: UniqueKey(),
      width: columnWidth,
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: ReorderableListView(
          proxyDecorator: _taskProxyDecorator,
          padding: EdgeInsets.all(5),
          header: CategoriesTableHeaderItem(
              categoryId: category.id, isEditModeOn: _isEditModeOn),
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

  List<Widget> _createColumnsList() {
    List<Widget> result = [];
    var categories =
        Provider.of<CategoriesProvider>(context, listen: false).itemsSorted;
    var categorizedMap =
        Provider.of<TasksProvider>(context, listen: false).categorizedMap;

    for (var category in categories) {
      result.add(
        _createCategoryColumn(
          context,
          category,
          categorizedMap[category.id] != null
              ? categorizedMap[category.id]!
              : [],
        ),
      );
    }
    return result;
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.all(1),
      color: Colors.white70,
      child: child,
    );
  }

  Widget _createTableItem(Task task) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      key: UniqueKey(),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: _isCarouselModeOn
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: DailyViewListItem(
                  task: task,
                ),
              )
            : CategoriesTableItem(
                task: task,
              ),
      ),
    );
  }

  Widget _createCarousel() {
    var categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: true);

    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 7),
                child: AnimatedSmoothIndicator(
                  activeIndex: _carouselCurrentPage,
                  count: categoriesProvider.items.length,
                  effect: WormEffect(
                    dotWidth: 14,
                    dotHeight: 14,
                    activeDotColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onDotClicked: (index) {
                    setState(() {
                      _carouselCurrentPage = index;
                      _carouselController.animateToPage(_carouselCurrentPage);
                    });
                  },
                ),
              ),
              CarouselSlider(
                items: _createColumnsList(),
                carouselController: _carouselController,
                options: CarouselOptions(
                  autoPlay: false,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _carouselCurrentPage = index;
                    });
                  },
                  aspectRatio: 3 / 3.8,
                  initialPage: _carouselCurrentPage,
                ),
              ),
            ],
          ),
          if (_carouselCurrentPage > 0)
            Positioned(
              left: -5,
              top: -5,
              child: IconButton(
                iconSize: 35,
                onPressed: () {
                  _carouselController.previousPage();
                },
                icon: Icon(
                  Icons.arrow_circle_left,
                  color: Theme.of(context).colorScheme.primary.withAlpha(200),
                ),
              ),
            ),
          if (_carouselCurrentPage < categoriesProvider.items.length - 1)
            Positioned(
              right: -5,
              top: -5,
              child: IconButton(
                iconSize: 35,
                onPressed: () {
                  _carouselController.nextPage();
                },
                icon: Icon(
                  Icons.arrow_circle_right,
                  color: Theme.of(context).colorScheme.primary.withAlpha(200),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: true);

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
              child: Padding(
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: _isCarouselModeOn
                      ? _createCarousel()
                      : ReorderableListView(
                          scrollDirection: Axis.horizontal,
                          proxyDecorator: _columnProxyDecorator,
                          children: _createColumnsList(),
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              categoriesProvider.updateOrderIndex(
                                  oldIndex, newIndex);
                            });
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
