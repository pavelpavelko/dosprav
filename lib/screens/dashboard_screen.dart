import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:dosprav/widgets/create_task_sheet.dart';
import 'package:dosprav/widgets/daily_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTabIndex = 0;

  static const List<Widget> _tabViews = <Widget>[
    DailyView(),
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
        return "All";
      case 2:
        return "Settings";
      case 0:
      default:
        return "Home";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitleText()),
//        backgroundColor: Theme.of(context).colorScheme.primary,
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
        sheetTopBarColor: Theme.of(context).colorScheme.primary,
        actionButtonFrameColor: Theme.of(context).colorScheme.secondary,
        actionButtonColor: Theme.of(context).colorScheme.primary,
        actionButtonSize: 60,
        child: IndexedStack(
          index: _selectedTabIndex,
          children: _tabViews,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedTabIndex,
        iconSize: 28,
        selectedFontSize: 15,
        unselectedFontSize: 13,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        showUnselectedLabels: false,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "All",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
