import 'package:flutter/material.dart';

import 'package:dosprav/widgets/view_preview.dart';

class CalendarViewPreview extends StatelessWidget {
  CalendarViewPreview({ Key? key }) : super(key: key);

  final tutorialTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: "Prompt",
    color: Colors.white,
  );

  late final ColorScheme themeColorScheme;

  List<Widget> _getPages() {
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
          "The Calendar view is a tool that helps you manage your goals and track your progress for them daily.\nThe Calendar view allows you to track something you want to achieve, like some good habits, or vice-versa, that you try to avoid.\nAlso, it shows you the color indicator for each goal that represents the current state of progress. The color calculation is based on the goal's rule, which you can specify composing a goal.\nThe tracking period for these calculations is a week.\nLook at the Tutorial to familiarize yourself with Calendar view functionality.",
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
            "Congratulations! You have completed the Calendar view tutorial. You can use it now to improve your efficiency.\nEnjoy it!",
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
      backgroundView: Container(),
    );
  }
}