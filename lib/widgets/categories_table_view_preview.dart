import 'package:flutter/material.dart';

import 'package:dosprav/widgets/view_preview.dart';

class CategoriesTableViewPreview extends StatelessWidget {
  CategoriesTableViewPreview({ Key? key }) : super(key: key);

  final tutorialTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: "Prompt",
    color: Colors.white,
  );

  late final ColorScheme themeColorScheme;

  // List<Task> _getTutorialTasks() {
  //   var result = [
  //     Task(
  //       name: "Pass the tutorial",
  //       description: "",
  //       categoryId: "",
  //       timestampCreated: DateTime.now(),
  //       dueDate: DateTime.now(),
  //       intervalDuration: Duration(days: 0),
  //       priorityOrder: 1,
  //     ),
  //     Task(
  //       name: "Daily Workouts",
  //       description: "",
  //       categoryId: "",
  //       timestampCreated: DateTime.now(),
  //       dueDate: DateTime.now(),
  //       intervalDuration: Duration(days: 1),
  //       priorityOrder: 0,
  //     ),
  //   ];
  //   result.sort();
  //   return result;
  // }

  List<Widget> _getPages() {
//    var tasks = _getTutorialTasks();

    List<Widget> pages = [
      _createMainDescriptionPage(),
      _createTutorialCompletePage(),
    ];
    return pages;
  }

    Widget _createMainDescriptionPage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.only(top: 15, left: 25, right: 25, bottom: 15),
      child: SingleChildScrollView(
        child: Text(
          "The Categories Table view is a tool that helps you manage your categories and corresponding tasks.\nReprioritize them by reordering, where the leftmost category and the topmost task have the highest priority.\nThe Categories Table view will help you progress on many projects simultaneously and efficiently.\nLook at the Tutorial to familiarize yourself with Categories Table view functionality.",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: "Prompt",
            color: Colors.white,
          ),
        ),
      ),
    );
  }

    Widget _createTutorialCompletePage() {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Icon(
          Icons.check,
          size: 100,
          color: themeColorScheme.primary,
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Congratulations! You have completed the Categories Table view tutorial. You can use it now to improve your efficiency.\nEnjoy it!",
            textAlign: TextAlign.center,
            style: tutorialTextStyle,
          ),
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    themeColorScheme = Theme.of(context).colorScheme;

    List<Widget> pages = _getPages();

    return ViewPreview(
      previewPages: pages,
//      backgroundView: CategoriesTableView(),
      backgroundView: Container(),
    );
  }
}