import 'package:flutter/material.dart';

class PickerDialog<T> extends StatefulWidget {
  const PickerDialog({
    Key? key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  final String title;
  final T selectedItem;
  final List<T> items;

  final Function onCancel;
  final void Function(T) onConfirm;

  @override
  _PickerDialogState createState() => _PickerDialogState<T>();
}

class _PickerDialogState<T> extends State<PickerDialog> {
  T? _selectedItem;

  @override
  void initState() {
    _selectedItem = widget.selectedItem;
    super.initState();
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
              widget.title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: widget.items.map(
                  (item) {
                    return RadioListTile<T>(
                      title: Text(item.toString()),
                      value: item,
                      groupValue: _selectedItem,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedItem = value;
                          });
                        }
                      },
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: ButtonStyle(),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  widget.onCancel();
                },
                child: Text("CANCEL"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextButton(
                  onPressed: () {
                    widget.onConfirm(_selectedItem!);
                    Navigator.of(context).pop(true);
                  },
                  child: Text("OK"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class IntervalModel {
  const IntervalModel(this.name, this.interval);
  final String name;
  final Duration interval;

  @override
  String toString() {
    return name;
  }

  static const List<IntervalModel> intervals = <IntervalModel>[
    IntervalModel("Once", Duration(days: 0)),
    IntervalModel("Everyday", Duration(days: 1)),
    IntervalModel("Every 2 days", Duration(days: 2)),
    IntervalModel("Semiweekly", Duration(days: 3)),
    IntervalModel("Weekly", Duration(days: 7)),
    IntervalModel("Semimonthly", Duration(days: 14)),
    IntervalModel("Every 3 weeks", Duration(days: 21)),
    IntervalModel("Monthly", Duration(days: 30)),
  ];

  static IntervalModel getIntervalModel(Duration interval) {
    return intervals.firstWhere((element) => element.interval == interval);
  }
}
