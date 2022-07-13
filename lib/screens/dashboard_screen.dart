import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/widgets/create_task_sheet.dart';
import 'package:dosprav/models/task.dart';
import 'package:dosprav/providers/tasks_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTabIndex = 0;

  static const List<Widget> _tabViews = <Widget>[
    Icon(
      Icons.home,
      size: 80,
    ),
    Icon(
      Icons.list,
      size: 80,
    ),
    ElevatedButton(
      onPressed: _logout,
      child: Text("LOGOUT"),
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  static void _logout() {
    FirebaseAuth.instance.signOut();
  }

  String _appBarTitleText() {
    switch (_selectedTabIndex) {
      case 1:
        return "ALL";
      case 2:
        return "SETTINGS";
      case 0:
      default:
        return "HOME";
    }
  }

  void _createTask(Task newTask) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "The \"${newTask.name}\" task created.",
          textAlign: TextAlign.center,
        ),
      ),
    );

    Provider.of<TasksProvider>(context, listen: false).addTask(newTask);

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitleText()),
        backgroundColor: Colors.blue[400],
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 15),
            onPressed: () {},
            icon: Icon(
              Icons.person,
            ),
          ),
        ],
      ),
      body: CreateTaskSheet(
        onTaskCreated: _createTask,
        child: IndexedStack(
          index: _selectedTabIndex,
          children: _tabViews,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedTabIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.orange[400],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "ALL",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "SETTINGS",
          ),
        ],
      ),
    );
  }
}
