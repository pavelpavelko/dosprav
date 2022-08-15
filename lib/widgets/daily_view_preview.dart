import 'dart:math';

import 'package:flutter/material.dart';

import 'package:dosprav/models/task.dart';
import 'package:dosprav/widgets/daily_view.dart';
import 'package:dosprav/widgets/daily_view_list_item.dart';
import 'package:dosprav/providers/categories_provider.dart';
import 'package:dosprav/widgets/view_preview.dart';

class DailyViewPreview extends StatelessWidget {
  DailyViewPreview({Key? key}) : super(key: key);

  final tutorialTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: "Prompt",
    color: Colors.white,
  );

  late final ColorScheme themeColorScheme;

  List<Task> _getTutorialTasks() {
    var result = [
      Task(
        id: UniqueKey().toString(),
        uid: "",
        name: "Pass the tutorial",
        description: "",
        categoryId: CategoriesProvider.tempStudyCategoryId,
        timestampCreated: DateTime.now(),
        dueDate: DateTime.now(),
        intervalDuration: Duration(days: 0),
        priorityOrder: 1,
      ),
      Task(
        id: UniqueKey().toString(),
        uid: "",
        name: "Daily Workouts",
        description: "",
        categoryId: CategoriesProvider.tempStudyCategoryId,
        timestampCreated: DateTime.now(),
        dueDate: DateTime.now(),
        intervalDuration: Duration(days: 1),
        priorityOrder: 0,
      ),
    ];
    result.sort();
    return result;
  }

  List<Widget> _getPages() {
    var tasks = _getTutorialTasks();

    List<Widget> pages = [
      _createMainDescriptionPage(),
      _createTapHintPage(tasks[1]),
      _createSwipeRightHintPage(tasks[1]),
      _createSwipeLeftHintPage(tasks[1]),
      _createFilterByDoneHintPage(),
      _createFilterByWeekHintPage(),
      _createFilterByThirdToDoHintPage(),
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
          "The Daily List view is a tool that helps you manage your daily routine and recurrent tasks.\nYou do not need to keep all these in your mind anymore since do.sprav application and Daily List view, in particular, will manage them all for you.\nPlease look at the Tutorial to familiarize yourself with Daily List functionality better.",
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

  Widget _createTapHintPage(Task task) {
    return Stack(
      children: [
        Positioned(
          bottom: 15,
          left: 25,
          right: 20,
          child: Text(
            "Tap on task for more details and actions.",
            textAlign: TextAlign.center,
            style: tutorialTextStyle,
          ),
        ),
        Positioned(
          top: 124,
          left: 0,
          right: 0,
          child: IgnorePointer(
            ignoring: true,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: DailyViewListItem(
                task: task,
              ),
            ),
          ),
        ),
        Positioned(
          top: 170,
          left: 150,
          child: Icon(
            Icons.touch_app_rounded,
            color: themeColorScheme.secondary,
            size: 65,
          ),
        ),
      ],
    );
  }

  Widget _createSwipeRightHintPage(Task task) {
    return Stack(
      children: [
        Positioned(
          bottom: 15,
          left: 25,
          right: 20,
          child: Text(
            "Swipe task right to complete it.",
            textAlign: TextAlign.center,
            style: tutorialTextStyle,
          ),
        ),
        Positioned(
          top: 124,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 75,
            color: Colors.white,
            child: Container(
              color: themeColorScheme.primary.withAlpha(175),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 25),
              child: Icon(
                Icons.check_outlined,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ),
        Positioned(
          top: 124,
          left: 85,
          right: 0,
          child: IgnorePointer(
            ignoring: true,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: DailyViewListItem(
                task: task,
              ),
            ),
          ),
        ),
        Positioned(
          top: 170,
          left: 190,
          child: Icon(
            Icons.touch_app_rounded,
            color: themeColorScheme.secondary,
            size: 65,
          ),
        ),
        Positioned(
          top: 180,
          left: 250,
          child: Icon(
            Icons.arrow_right_alt_sharp,
            color: themeColorScheme.secondary,
            size: 65,
          ),
        ),
      ],
    );
  }

  Widget _createSwipeLeftHintPage(Task task) {
    return Stack(
      children: [
        Positioned(
          bottom: 15,
          left: 25,
          right: 20,
          child: Text(
            "Swipe task left to\ndelete it.",
            textAlign: TextAlign.center,
            style: tutorialTextStyle,
          ),
        ),
        Positioned(
          top: 124,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 75,
            color: Colors.white,
            child: Container(
              color: themeColorScheme.error.withAlpha(175),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 30),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
        Positioned(
          top: 124,
          right: 85,
          left: 0,
          child: IgnorePointer(
            ignoring: true,
            child: Container(
              color: Colors.white,
              width: double.infinity,
              child: DailyViewListItem(
                task: task,
              ),
            ),
          ),
        ),
        Positioned(
          top: 170,
          left: 110,
          child: Icon(
            Icons.touch_app_rounded,
            color: themeColorScheme.secondary,
            size: 65,
          ),
        ),
        Positioned(
          top: 180,
          left: 50,
          child: Transform.rotate(
            angle: pi,
            child: Icon(
              Icons.arrow_right_alt_sharp,
              color: themeColorScheme.secondary,
              size: 65,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createFilterByDoneHintPage() {
    return Stack(
      children: [
        Positioned(
          bottom: 60,
          left: 25,
          right: 20,
          child: Text(
            "You can filter your tasks list by Done/Active checkbox.",
            textAlign: TextAlign.center,
            style: tutorialTextStyle,
          ),
        ),
        Positioned(
          top: 7,
          left: 45,
          child: Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: themeColorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_box,
              color: themeColorScheme.secondary,
            ),
          ),
        ),
        Positioned(
          top: 45,
          left: 70,
          child: Transform.rotate(
            angle: pi / 4 * 5,
            child: Icon(
              Icons.arrow_right_alt_sharp,
              size: 100,
              color: themeColorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createFilterByWeekHintPage() {
    return Stack(
      children: [
        Positioned(
          bottom: 35,
          left: 25,
          right: 20,
          child: Text(
            "The checkbox above helps you to see, either tasks\nfor today, or for upcoming week as well.",
            textAlign: TextAlign.center,
            style: tutorialTextStyle,
          ),
        ),
        Positioned(
          top: 7,
          left: 158,
          child: Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: themeColorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.next_plan_rounded,
              color: themeColorScheme.secondary,
            ),
          ),
        ),
        Positioned(
          top: 45,
          left: 127,
          child: Transform.rotate(
            angle: pi / 2 * 3,
            child: Icon(
              Icons.arrow_right_alt_sharp,
              size: 100,
              color: themeColorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createFilterByThirdToDoHintPage() {
    return Stack(
      children: [
        Positioned(
          bottom: 60,
          left: 25,
          right: 20,
          child: Text(
            "You can filter your tasks list by Third [TODO] checkbox.",
            textAlign: TextAlign.center,
            style: tutorialTextStyle,
          ),
        ),
        Positioned(
          top: 7,
          left: 271,
          child: Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: themeColorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.wb_incandescent_rounded,
              color: themeColorScheme.secondary,
            ),
          ),
        ),
        Positioned(
          top: 45,
          left: 184,
          child: Transform.rotate(
            angle: pi / 4 * 7,
            child: Icon(
              Icons.arrow_right_alt_sharp,
              size: 100,
              color: themeColorScheme.secondary,
            ),
          ),
        ),
      ],
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
            "Congratulations! You have completed the Daily List view tutorial. Please use it now to improve your efficiency. Enjoy it!",
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
      backgroundView: DailyView(
        demoItems: _getTutorialTasks(),
      ),
    );
  }
}
