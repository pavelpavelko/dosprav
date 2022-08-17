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
import 'package:dosprav/screens/daily_view_screen.dart';
import 'package:dosprav/providers/categories_provider.dart';
import 'package:dosprav/providers/view_models_provider.dart';
import 'package:dosprav/screens/categories_table_view_screen.dart';
import 'package:dosprav/providers/home_slots_provider.dart';
import 'package:dosprav/screens/calendar_view_screen.dart';
import 'package:dosprav/providers/calendar_goals_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 56, 179, 199),
    secondary: Color.fromARGB(255, 255, 167, 120),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TasksProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoriesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ViewModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeSlotsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CalendarGoalsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'do.sprav',
        theme: ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
          fontFamily: "Baloo2",
          appBarTheme: ThemeData.light().appBarTheme.copyWith(
                centerTitle: true,
                titleTextStyle: TextStyle(
                  fontFamily: "Prompt",
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
        ),
        home: const MyHomePage(title: 'do.sprav'),
        routes: {
          TaskDetailScreen.routeName: (context) => TaskDetailScreen(),
          TaskComposeScreen.routeName: (context) => TaskComposeScreen(),
          DailyViewScreen.routeName: (context) => DailyViewScreen(),
          CategoriesTableViewScreen.routeName:(context) => CategoriesTableViewScreen(),
          CalendarViewScreen.routeName:(context) => CalendarViewScreen(),
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
