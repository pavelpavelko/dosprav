import 'package:flutter/material.dart';

class CreateTaskSheet extends StatefulWidget {
  CreateTaskSheet({
    Key? key,
    required this.child,
    this.sheetTopBarHeight = 5,
    this.sheetContentHeight = 250,
    this.durationOnPan = const Duration(milliseconds: 50),
    this.durationOnTap = const Duration(milliseconds: 700),
    this.actionButtonSize = 70,
    this.actionButtonIcon = Icons.arrow_circle_right_outlined,
    this.actionButtonColor = Colors.blue,
    this.actionButtonFrameColor = Colors.yellow,
    this.sheetTopBarColor = Colors.cyan,
    this.sheetBackgroundColor = Colors.white,
    this.animationCurve = Curves.easeIn,
    this.emergenceType = EmergenceType.cover,
    required this.onTaskCreated,
  }) : super(key: key);

  final Widget child;

  final double sheetTopBarHeight;
  final double sheetContentHeight;

  final Duration durationOnPan;
  final Duration durationOnTap;

  final double actionButtonSize;
  final IconData actionButtonIcon;

  final Color actionButtonColor;
  final Color actionButtonFrameColor;

  final Color sheetTopBarColor;
  final Color sheetBackgroundColor;

  final Curve animationCurve;

  final EmergenceType emergenceType;

  final void Function(
    String taskName,
  ) onTaskCreated;

  @override
  _CreateTaskSheetState createState() => _CreateTaskSheetState();
}

enum EmergenceType {
  expand,
  cover,
}

class _CreateTaskSheetState extends State<CreateTaskSheet>
    with SingleTickerProviderStateMixin {
  // ignore: prefer_final_fields
  GlobalKey _stackKey = GlobalKey();

  AnimationController? _controller;
  Animation<Size>? _heightAnimation;
  Animation<Offset>? _actionsPositionAnimation;
  Animation<double>? _actionsRotationAnimation;
  Animation<double>? _actionsFadeAnimation;

  TextEditingController? _editTextController;

  @override
  void initState() {
    super.initState();

    _editTextController = TextEditingController();

    _controller = AnimationController(
      vsync: this,
      duration: widget.durationOnTap,
    );
    _heightAnimation = Tween<Size>(
      begin: Size(double.infinity, 0),
      end: Size(double.infinity, widget.sheetContentHeight),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: widget.animationCurve,
      ),
    );

    _actionsPositionAnimation = Tween<Offset>(
      begin: Offset(0, -widget.actionButtonSize / 2),
      end: Offset(0, widget.sheetContentHeight - widget.actionButtonSize / 2),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: widget.animationCurve,
      ),
    );

    _actionsRotationAnimation = Tween<double>(
      begin: 0.75,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: widget.animationCurve,
      ),
    );

    _actionsFadeAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: widget.animationCurve,
      ),
    );

    _heightAnimation?.addListener(() => setState(() {}));
    _actionsPositionAnimation?.addListener(() => setState(() {}));
    _actionsRotationAnimation?.addListener(() => setState(() {}));
    _actionsFadeAnimation?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller?.dispose();
    _editTextController?.dispose();
    super.dispose();
  }

  double globalToSheetHeightPercent(Offset global) {
    final RenderBox renderBox =
        _stackKey.currentContext?.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.globalToLocal(global);
    double height = size.height - offset.dy - widget.sheetTopBarHeight;
    return (1 / widget.sheetContentHeight) * height;
  }

  Widget? _createSheetMainContent() {
    if (_controller!.value < 1) {
      return null;
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's create a task!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          TextField(
            controller: _editTextController,
            decoration: InputDecoration(hintText: 'New Task'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _stackKey,
      children: [
        if (widget.emergenceType == EmergenceType.cover)
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            color: Colors.grey,
            child: widget.child,
          ),
        if (widget.emergenceType == EmergenceType.cover)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.only(top: widget.sheetTopBarHeight),
              color: widget.sheetTopBarColor,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: _heightAnimation?.value.height,
                color: widget.sheetBackgroundColor,
                padding: EdgeInsets.all(8),
                child: _createSheetMainContent(),
              ),
            ),
          ),
        if (widget.emergenceType == EmergenceType.expand)
          Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: Colors.grey,
                  child: widget.child,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: widget.sheetTopBarHeight),
                color: widget.sheetTopBarColor,
                child: Container(
                  width: double.infinity,
                  height: _heightAnimation?.value.height,
                  color: widget.sheetBackgroundColor,
                  padding: EdgeInsets.all(8),
                  child: _createSheetMainContent(),
                ),
              ),
            ],
          ),
        Positioned(
          bottom:
              widget.sheetTopBarHeight + _actionsPositionAnimation!.value.dy,
          right: -widget.actionButtonSize / 2,
          child: RotationTransition(
            turns: _actionsRotationAnimation!,
            child: Transform(
              transform:
                  Matrix4.translationValues(-widget.actionButtonSize / 2, 0, 0),
              alignment: FractionalOffset.centerRight,
              child: GestureDetector(
                onPanUpdate: (details) {
                  _controller?.animateTo(
                      globalToSheetHeightPercent(details.globalPosition));
                },
                onPanStart: (_) {
                  _controller?.duration = widget.durationOnPan;
                },
                onPanEnd: (_) {
                  _controller?.duration = widget.durationOnTap;
                  _controller?.animateTo(_controller!.value >= 0.5 ? 1 : 0);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: widget.actionButtonFrameColor,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          iconSize: widget.actionButtonSize,
                          padding: EdgeInsets.zero,
                          splashRadius: widget.actionButtonSize / 2,
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: widget.actionButtonColor,
                          ),
                          onPressed: () {
                            _controller?.reverse();
                          }),
                      IconButton(
                        iconSize: widget.actionButtonSize,
                        padding: EdgeInsets.zero,
                        splashRadius: widget.actionButtonSize / 2,
                        icon: Icon(
                          widget.actionButtonIcon,
                          color: widget.actionButtonColor,
                        ),
                        onPressed: () {
                          if (_controller!.value == 1) {
                            widget
                                .onTaskCreated(_editTextController!.value.text);
                          } else {
                            _controller?.forward();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: _actionsPositionAnimation!.value.dy +
              widget.sheetTopBarHeight -
              widget.actionButtonSize / 2,
          right: 0,
          child: FadeTransition(
            opacity: _actionsFadeAnimation!,
            child: (_controller!.value == 1)
                ? null
                : Container(
                    width: widget.actionButtonSize * 2,
                    height: widget.actionButtonSize,
                    color: widget.sheetTopBarColor,
                    padding: EdgeInsets.only(top: widget.sheetTopBarHeight),
                    child: Container(
                      color: widget.sheetBackgroundColor,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
