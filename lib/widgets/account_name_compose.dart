import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountNameCompose extends StatefulWidget {
  const AccountNameCompose({Key? key, required this.userName})
      : super(key: key);

  final String userName;

  @override
  _AccountNameComposeState createState() => _AccountNameComposeState();
}

class _AccountNameComposeState extends State<AccountNameCompose> {
  late final TextEditingController _accountNameController;

  late String _accountUserName;
  bool _isErrorTextVisible = false;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _accountUserName = widget.userName;

    _accountNameController = TextEditingController(
      text: _accountUserName,
    );
  }

  bool _isSaveAvailable() {
    return _accountUserName.trim().isNotEmpty;
  }

  void _trySaveUserName() {
    setState(() {
      if (_isSaveAvailable()) {
        _saveUserName();
      } else {
        _isErrorTextVisible = true;
      }
    });
  }

  Future<void> _saveUserName() async {
    try {
      setState(() {
        _isSaving = true;
      });
      await FirebaseAuth.instance.currentUser?.updateDisplayName(_accountUserName);

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Saving user name failed. Please try again later.",
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
              "Change User Name",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 20,
              ),
            ),
          ),
          _isSaving
              ? Padding(
                  padding: EdgeInsets.only(top: 25, bottom: 25),
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 0),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.name,
                    controller: _accountNameController,
                    onChanged: (value) {
                      setState(() {
                        _accountUserName = value;
                      });
                    },
                    onSubmitted: (value) => _trySaveUserName(),
                    decoration: InputDecoration(
                      labelText: "User Name",
                      errorText: _isErrorTextVisible
                          ? "User name must not be empty"
                          : null,
                    ),
                  ),
                ),
          if (!_isSaving)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          Row(
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
                    _trySaveUserName();
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
