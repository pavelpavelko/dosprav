import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:dosprav/widgets/create_task_sheet.dart';
import 'package:dosprav/widgets/home_slots.dart';
import 'package:dosprav/widgets/views_gallery.dart';
import 'package:dosprav/screens/account_screen.dart';
import 'package:dosprav/widgets/integrations_gallery.dart';
import 'package:dosprav/providers/home_slots_provider.dart';
import 'package:dosprav/providers/categories_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    Provider.of<CategoriesProvider>(context, listen: false)
        .fetchCategories()
        .then((_) {
      if (mounted) {
        Provider.of<HomeSlotsProvider>(context, listen: false).fetchHomeSlots();
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  String _appBarTitleText(bool isHomeEmpty) {
    if (isHomeEmpty) {
      return _selectedTabIndex == 0 ? "Views" : "Integrations";
    }

    switch (_selectedTabIndex) {
      case 1:
        return "Views";
      case 2:
        return "Integrations";
      case 0:
      default:
        return "Home";
    }
  }

  @override
  Widget build(BuildContext context) {
    var isHomeSlotsEmpty =
        Provider.of<HomeSlotsProvider>(context, listen: true).items.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitleText(isHomeSlotsEmpty)),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 15),
            onPressed: () {
              Navigator.of(context).pushNamed(AccountScreen.routeName);
            },
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
          children: [
            if (!isHomeSlotsEmpty) HomeSlots(),
            ViewsGallery(),
            IntegrationsGallery(),
          ],
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
        items: [
          if (!isHomeSlotsEmpty)
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: "Views",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_suggest_outlined),
            label: "Integrations",
          ),
        ],
      ),
    );
  }
}
