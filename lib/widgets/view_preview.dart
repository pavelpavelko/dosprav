import 'package:flutter/material.dart';

class ViewPreview extends StatefulWidget {
  const ViewPreview({
    Key? key,
    required this.previewPages,
    required this.backgroundView,
  }) : super(key: key);

  final List<Widget> previewPages;
  final Widget backgroundView;

  @override
  _ViewPreviewState createState() => _ViewPreviewState();
}

class _ViewPreviewState extends State<ViewPreview> {
  double tutorialCurrentPage = 0;
  final PageController tutorialPageController = PageController();

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

  Widget _createActivateButton() {
    return Expanded(
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.backgroundView,
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
                        children: widget.previewPages,
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
                    _createActivateButton(),
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
                  if (tutorialCurrentPage < widget.previewPages.length - 1)
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
                  if (tutorialCurrentPage == widget.previewPages.length - 1)
                    _createActivateButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
