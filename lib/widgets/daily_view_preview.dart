import 'dart:math';

import 'package:flutter/material.dart';

import 'package:dosprav/models/task.dart';
import 'package:dosprav/widgets/daily_view.dart';
import 'package:dosprav/widgets/daily_view_list_item.dart';
import 'package:dosprav/providers/categories_provider.dart';

class DailyViewPreview extends StatefulWidget {
  const DailyViewPreview({Key? key}) : super(key: key);

  @override
  _DailyViewPreviewState createState() => _DailyViewPreviewState();
}

class _DailyViewPreviewState extends State<DailyViewPreview> {
  double tutorialCurrentPage = 0;
  final PageController tutorialPageController = PageController();

  final tutorialTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: "Prompt",
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    tutorialPageController.addListener(() {
      setState(() {
        tutorialCurrentPage = tutorialPageController.page!;
      });
    });
  }

  @override
  void dispose() {
    tutorialPageController.dispose();
    super.dispose();
  }

  List<Task> _getTutorialTasks() {
    return [
      Task(
        id: UniqueKey().toString(),
        uid: "",
        name: "Install do.sprav",
        description: "",
        categoryId: CategoriesProvider.tempStudyCategoryId,
        timestampCreated: DateTime.now(),
        dueDate: DateTime.now(),
        intervalDuration: Duration(days: 0),
        priorityOrder: 3,
        isComplete: true,
      ),
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
          "The Daily List widget is a tool that helps you manage your daily routine and recurrent tasks.\nYou do not need to keep all these in your mind anymore since do.sprav application and Daily List widget, in particular, will manage them all for you.\nPlease look at the Tutorial to better familiarize yourself with Daily List functionality.",
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
            color: Theme.of(context).colorScheme.secondary,
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
              color: Theme.of(context).colorScheme.primary.withAlpha(175),
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
            color: Theme.of(context).colorScheme.secondary,
            size: 65,
          ),
        ),
        Positioned(
          top: 180,
          left: 250,
          child: Icon(
            Icons.arrow_right_alt_sharp,
            color: Theme.of(context).colorScheme.secondary,
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
              color: Theme.of(context).errorColor.withAlpha(175),
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
            color: Theme.of(context).colorScheme.secondary,
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
              color: Theme.of(context).colorScheme.secondary,
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
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_box,
              color: Theme.of(context).colorScheme.secondary,
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
              color: Theme.of(context).colorScheme.secondary,
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
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.next_plan_rounded,
              color: Theme.of(context).colorScheme.secondary,
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
              color: Theme.of(context).colorScheme.secondary,
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
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.wb_incandescent_rounded,
              color: Theme.of(context).colorScheme.secondary,
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
              color: Theme.of(context).colorScheme.secondary,
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
          color: Theme.of(context).colorScheme.primary,
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Congratulations! You have completed the Daily List tutorial. Please use it now to improve your efficiency. Enjoy it!",
            textAlign: TextAlign.center,
            style: tutorialTextStyle,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = _getPages();

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 105),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        height: 450,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  DailyView(
                    demoItems: _getTutorialTasks(),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withAlpha(180),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(10),
                      child: PageView(
                        controller: tutorialPageController,
                        children: pages,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  if (tutorialCurrentPage == 0)
                    Expanded(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Text(
                            "Activate",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (tutorialCurrentPage > 0)
                    Expanded(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            tutorialPageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.linear,
                            );
                          },
                          child: Text("Previous"),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Close"),
                      ),
                    ),
                  ),
                  if (tutorialCurrentPage < pages.length - 1)
                    Expanded(
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            tutorialPageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.linear,
                            );
                          },
                          child: Text(
                            tutorialCurrentPage == 0 ? "Tutorial" : "Next",
                          ),
                        ),
                      ),
                    ),
                  if (tutorialCurrentPage == pages.length - 1) Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
