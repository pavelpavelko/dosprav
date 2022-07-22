import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

import 'package:dosprav/screens/auth_screen.dart';
import 'package:dosprav/screens/dashboard_screen.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/screens/task_compose_screen.dart';
import 'package:dosprav/screens/task_detail_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => TasksProvider(),
      child: MaterialApp(
        title: 'do.sprav',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'do.sprav'),
        routes: {
          TaskDetailScreen.routeName :(context) => TaskDetailScreen(),
          TaskComposeScreen.routeName :(context) => TaskComposeScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return DashboardScreen();
            } else {
              return AuthScreen();
            }
          }),
    );
  }
}
