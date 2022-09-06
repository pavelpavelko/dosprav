import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:dosprav/providers/categories_provider.dart';
import 'package:dosprav/widgets/category_list.dart';
import 'package:dosprav/providers/tasks_provider.dart';

class CategoriesTableView extends StatefulWidget {
  const CategoriesTableView({
    Key? key,
    this.isCompletedVisible = false,
    this.isCarouselMode = false,
    this.isEditMode = false,
    this.isShortMode = false,
  }) : super(key: key);

  final bool isCompletedVisible;
  final bool isCarouselMode;
  final bool isEditMode;
  final bool isShortMode;

  @override
  State<CategoriesTableView> createState() => _CategoriesTableViewState();
}

class _CategoriesTableViewState extends State<CategoriesTableView> {
  bool _isCompletedVisible = false;
  bool _isCarouselMode = false;
  bool _isEditMode = false;
  bool _isLoading = false;

  final CarouselController _carouselController = CarouselController();

  int _carouselCurrentPage = 0;

  @override
  void initState() {
    super.initState();
    _isCompletedVisible = widget.isCompletedVisible;
    _isCarouselMode = widget.isCarouselMode;
    _isEditMode = widget.isEditMode;

    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<CategoriesProvider>(context, listen: false)
          .fetchCategories();
      if (mounted) {
        await Provider.of<TasksProvider>(context, listen: false).fetchTasks();
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cannot download categories. Please try again later.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _reorderCategories(int oldIndex, int newIndex) async {
    try {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      await Provider.of<CategoriesProvider>(context, listen: false)
          .updateOrderIndex(oldIndex, newIndex);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cannot reorder categories. Please try again later.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  List<Widget> _createColumnsList() {
    List<Widget> result = [];
    var categories =
        Provider.of<CategoriesProvider>(context, listen: false).itemsSorted;

    var categoriesProvider = Provider.of<CategoriesProvider>(context);

    double columnWidth;
    double approxPaddingSum = 30;
    if (_isCarouselMode) {
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

    for (var category in categories) {
      var categoryList = CategoryList(
        key: UniqueKey(),
        categoryId: category.id,
        isCompleteVisible: _isCompletedVisible,
        isEditMode: _isEditMode,
        width: columnWidth,
        isShortMode: widget.isShortMode,
        isCarouselMode: _isCarouselMode,
      );

      result.add(categoryList);
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

  Widget _createCarousel() {
    var categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: true);

    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding:
                    EdgeInsets.symmetric(vertical: widget.isShortMode ? 3 : 7),
                child: AnimatedSmoothIndicator(
                  activeIndex: _carouselCurrentPage,
                  count: categoriesProvider.items.length,
                  effect: WormEffect(
                    dotWidth: widget.isShortMode ? 10 : 14,
                    dotHeight: widget.isShortMode ? 10 : 14,
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
                  aspectRatio: widget.isShortMode ? 2 / 1.05 : 3 / 3.7,
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
    Provider.of<CategoriesProvider>(context, listen: true);

    var topPanelContainerSize = widget.isShortMode ? 28.0 : 35.0;
    var topPanelIzonSize = widget.isShortMode ? 20.0 : 25.0;

    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: 10, vertical: widget.isShortMode ? 5 : 10),
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
              padding: EdgeInsets.all(widget.isShortMode ? 3 : 5),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Container(
                        width: topPanelContainerSize,
                        height: topPanelContainerSize,
                        alignment: Alignment.center,
                        decoration: _isCompletedVisible
                            ? BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: topPanelIzonSize,
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
                        width: topPanelContainerSize,
                        height: topPanelContainerSize,
                        alignment: Alignment.center,
                        decoration: _isCarouselMode
                            ? BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: IconButton(
                          iconSize: topPanelIzonSize,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            _isCarouselMode
                                ? Icons.view_carousel_rounded
                                : Icons.view_carousel_outlined,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isCarouselMode = !_isCarouselMode;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  if (!widget.isShortMode)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Container(
                          width: topPanelContainerSize,
                          height: topPanelContainerSize,
                          alignment: Alignment.center,
                          decoration: _isEditMode
                              ? BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                )
                              : null,
                          child: IconButton(
                            iconSize: topPanelIzonSize,
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              _isEditMode
                                  ? Icons.edit_rounded
                                  : Icons.edit_outlined,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _isEditMode = !_isEditMode;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: _isCarouselMode
                            ? _createCarousel()
                            : ReorderableListView(
                                scrollDirection: Axis.horizontal,
                                proxyDecorator: _columnProxyDecorator,
                                children: _createColumnsList(),
                                onReorder: (int oldIndex, int newIndex) =>
                                    _reorderCategories(oldIndex, newIndex),
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
