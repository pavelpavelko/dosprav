import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/providers/categories_provider.dart';
import 'package:dosprav/models/category.dart';

class CategoryCompose extends StatefulWidget {
  const CategoryCompose({Key? key, this.categoryId}) : super(key: key);

  final String? categoryId;

  @override
  _CategoryComposeState createState() => _CategoryComposeState();
}

class _CategoryComposeState extends State<CategoryCompose> {
  Category? _categoryToEdit;
  late final CategoriesProvider _categoriesProvider;
  late final TextEditingController _categoryNameController;
  String _categoryName = "";
  bool _isErrorTextVisible = false;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);

    if (widget.categoryId != null) {
      _categoryToEdit = _categoriesProvider.getById(widget.categoryId!);
    }

    _categoryNameController = TextEditingController(
      text: _categoryToEdit != null ? _categoryToEdit!.name : "",
    );
  }

  bool _isSaveAvailable() {
    return _categoryName.trim().isNotEmpty;
  }

  void _trySaveCategory() {
    setState(() {
      if (_isSaveAvailable()) {
        _saveCategory();
      } else {
        _isErrorTextVisible = true;
      }
    });
  }

  Future<void> _saveCategory() async {
    try {
      setState(() {
        _isSaving = true;
      });
      if (_categoryToEdit != null) {
        await _categoriesProvider.updateCategory(
          Category.fromCategory(
            origin: _categoryToEdit!,
            name: _categoryName,
          ),
        );
      } else {
        await _categoriesProvider.addCategory(
          Category(
            name: _categoryName,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Saving category failed. Please try again later.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Text(
              _categoryToEdit != null ? "Edit Category" : "Create Category",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 0),
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.name,
              controller: _categoryNameController,
              onChanged: (value) {
                setState(() {
                  _categoryName = value;
                });
              },
              onSubmitted: (value) => _trySaveCategory(),
              decoration: InputDecoration(
                labelText: "Category Name",
                errorText: _isErrorTextVisible
                    ? "Category name must not be empty"
                    : null,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          _isSaving
              ? Padding(
                  padding: EdgeInsets.all(6),
                  child: Center(child: CircularProgressIndicator()))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: ButtonStyle(),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("CANCEL"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextButton(
                        onPressed: () {
                          _trySaveCategory();
                        },
                        child: Text("SAVE"),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
