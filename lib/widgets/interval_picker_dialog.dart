import 'package:flutter/material.dart';

import 'package:dosprav/helpers/task_helper.dart';

class IntervalPickerDialog extends StatefulWidget {
  const IntervalPickerDialog({
    Key? key,
    required this.selectedItem,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  final IntervalModel selectedItem;

  final Function onCancel;
  final Function(IntervalModel value) onConfirm;

  @override
  _IntervalPickerDialogState createState() => _IntervalPickerDialogState();
}

class _IntervalPickerDialogState extends State<IntervalPickerDialog> {
  IntervalModel? _selectedInterval;

  @override
  void initState() {
    _selectedInterval = widget.selectedItem;
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
              "Pick an interval for the task",
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
                children: IntervalModel.intervals.map(
                  (item) {
                    return RadioListTile<IntervalModel>(
                      title: Text(item.name),
                      value: item,
                      groupValue: _selectedInterval,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedInterval = value;
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
                    widget.onConfirm(_selectedInterval!);
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
