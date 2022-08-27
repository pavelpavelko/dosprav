import 'package:dosprav/models/calendar_goal_track.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/widgets/create_task_sheet.dart';
import 'package:dosprav/widgets/home_slots.dart';
import 'package:dosprav/widgets/views_gallery.dart';
import 'package:dosprav/providers/calendar_goal_tracks_provider.dart';
import 'package:dosprav/providers/calendar_goals_provider.dart';
import 'package:dosprav/providers/categories_provider.dart';
import 'package:dosprav/providers/home_slots_provider.dart';
import 'package:dosprav/providers/tasks_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTabIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _logout(BuildContext context) {
    Provider.of<CategoriesProvider>(context, listen: false).clear();
    Provider.of<TasksProvider>(context, listen: false).clear();
    Provider.of<CalendarGoalsProvider>(context, listen: false).clear();
    Provider.of<CalendarGoalTracksProvider>(context, listen: false).clear();
    Provider.of<HomeSlotsProvider>(context, listen: false).clear();

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
      body: Padding(
        padding: EdgeInsets.only(top: 0),
        child: CreateTaskSheet(
          sheetTopBarColor: Theme.of(context).colorScheme.primary,
          actionButtonFrameColor: Theme.of(context).colorScheme.secondary,
          actionButtonColor: Theme.of(context).colorScheme.primary,
          actionButtonSize: 60,
          child: IndexedStack(
            index: _selectedTabIndex,
            children: [
              HomeSlots(),
              ViewsGallery(),
              Center(
                child: ElevatedButton(
                  onPressed: (() => _logout(context)),
                  child: Text("LOGOUT"),
                ),
              ),
            ],
          ),
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
