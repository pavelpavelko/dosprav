import 'package:flutter/material.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(
              height: 30,
            ),
            Text(
              "DO.SPRAV",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Image(
              image: AssetImage("assets/images/target_arrow.png"),
              height: 150,
              width: double.infinity,
            ),
            SizedBox(
              height: 20,
            ),
            AuthForm(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
