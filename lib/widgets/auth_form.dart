import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  AuthFormState createState() => AuthFormState();
}

enum AuthState {
  signIn,
  signUp,
}

class AuthFormState extends State<AuthForm> {
  AuthState _authState = AuthState.signUp;
  final TextEditingController _textController = TextEditingController();
  String _forgotEmail = "";

  String _username = "";
  String _email = "";
  String _password = "";

  bool _isForgotEmailValid = true;
  bool _isForgotEmailRegistered = true;

  final _formKey = GlobalKey<FormState>();

  void _setAuthState(AuthState newState) {
    setState(() {
      _authState = newState;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onForgotEmailSendPressed() {
    _isForgotEmailRegistered = false;
    var isEmailValid = _isEmailValid(_forgotEmail);

    if (!isEmailValid) {
      _isForgotEmailValid = false;
    } else {
      _isForgotEmailValid = true;
      _isForgotEmailRegistered = _isEmailRegistered(_forgotEmail);
    }

    if (isEmailValid && _isForgotEmailRegistered) {
      Navigator.of(context).pop(_forgotEmail);
    } else {
      setState(() {
        Navigator.of(context).pop();
        _showForgotEmailDialog(context);
      });
    }
  }

  Future<void> _showForgotEmailDialog(BuildContext context) async {
    var result = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Forgot password?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Please enter your email address and we will send the password there."),
            TextField(
              controller: _textController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                _forgotEmail = value;
              },
              onSubmitted: (value) => _onForgotEmailSendPressed(),
              decoration: InputDecoration(
                labelText: 'Email address',
                errorText: !_isForgotEmailValid
                    ? "Please enter a valid email address."
                    : !_isForgotEmailRegistered
                        ? "Please enter a registered email address"
                        : null,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _onForgotEmailSendPressed();
            },
            child: Text("Send"),
          ),
        ],
      ),
    );

    if (result == null) {
      _textController.clear();
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Forgot password?"),
          content: Text(
              "The password is sent to your email. Please check it out in a few minutes."),
          actions: [
            ElevatedButton(
              onPressed: () {
                _textController.clear();
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        ),
      );
    }
  }

  void _saveForm() {
    var isValid = _formKey.currentState?.validate();

    if (isValid != true) {
      return;
    }
    _formKey.currentState?.save();
  }

  bool _isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool _isEmailRegistered(String email) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Text(
                  _authState == AuthState.signUp
                      ? "Let's get to know each other!"
                      : "Welcome, good to see you again!",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_authState == AuthState.signUp)
                      TextFormField(
                        key: ValueKey("username"),
                        decoration: InputDecoration(label: Text("Username")),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          var username = value?.trim() ?? "";
                          if (username.length < 3) {
                            return "Please enter three characters at least.";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _username = value?.trim() ?? "";
                        },
                      ),
                    TextFormField(
                      key: ValueKey("email"),
                      decoration: InputDecoration(label: Text("Email")),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        _email = value;
                      },
                      validator: (value) {
                        var email = value?.trim() ?? "";
                        if (!_isEmailValid(email)) {
                          return "Please enter a valid email address.";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    TextFormField(
                      key: ValueKey("password"),
                      decoration: InputDecoration(label: Text("Password")),
                      obscureText: true,
                      textInputAction: _authState == AuthState.signUp
                          ? TextInputAction.next
                          : TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        var password = value?.trim() ?? "";
                        if (password.length < 6) {
                          return "Please enter six characters at least.";
                        } else {
                          _password = password;
                          return null;
                        }
                      },
                      onFieldSubmitted: (_) {
                        if (_authState == AuthState.signIn) {
                          _saveForm();
                        }
                      },
                    ),
                    if (_authState == AuthState.signUp)
                      TextFormField(
                        key: ValueKey("confirmpassword"),
                        decoration:
                            InputDecoration(label: Text("Confirm password")),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          var confirmPassword = value?.trim() ?? "";
                          if (confirmPassword.length < 6) {
                            return "Please enter six characters at least.";
                          } else if (confirmPassword != _password) {
                            return "The passwords don't match.";
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          _saveForm();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        child: Text(_authState == AuthState.signUp
                            ? "SIGN UP"
                            : "SIGN IN"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Text(_authState == AuthState.signUp
                            ? "Already have an account?"
                            : "Create new account?"),
                        TextButton(
                          onPressed: () {
                            _setAuthState(_authState == AuthState.signUp
                                ? AuthState.signIn
                                : AuthState.signUp);
                          },
                          child: Text(_authState == AuthState.signUp
                              ? "Sign In"
                              : "Sign Up"),
                        ),
                      ],
                    ),
                    if (_authState == AuthState.signIn)
                      SizedBox(
                        height: 10,
                      ),
                    if (_authState == AuthState.signIn)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isForgotEmailValid = true;
                            _isForgotEmailRegistered = true;
                            _textController.text = _email;
                            _showForgotEmailDialog(context);
                          });
                        },
                        child: Text("Forgot password?"),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}