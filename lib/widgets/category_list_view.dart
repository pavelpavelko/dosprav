import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/categories_provider.dart';
import 'package:dosprav/widgets/category_list.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({
    Key? key,
    required this.categoryId,
    this.isShortMode = false,
  }) : super(key: key);

  final String categoryId;
  final bool isShortMode;

  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  bool _isCompletedVisible = false;

  @override
  Widget build(BuildContext context) {
    var categoriesProvider =
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
                    child: Card(
                      elevation: 3,
                      color: Theme.of(context).colorScheme.secondary,
                      margin: EdgeInsets.only(
                        top: 0,
                        left: 0,
                        right: 10,
                        bottom: 0,
                      ),
                      child: Container(
                        height: widget.isShortMode ? 25 : 30,
                        alignment: Alignment.center,
                        child: Text(
                          categoriesProvider.getById(widget.categoryId).name,
                          maxLines: 1,
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
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: CategoryList(
                    categoryId: widget.categoryId,
                    isShortMode: widget.isShortMode,
                    isHeaderVisible: false,
                    isCompleteVisible: _isCompletedVisible,
                    isCarouselMode: true,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
