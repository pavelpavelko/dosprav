import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dosprav/widgets/account_name_compose.dart';
import 'package:dosprav/providers/calendar_goal_tracks_provider.dart';
import 'package:dosprav/providers/calendar_goals_provider.dart';
import 'package:dosprav/providers/categories_provider.dart';
import 'package:dosprav/providers/home_slots_provider.dart';
import 'package:dosprav/providers/tasks_provider.dart';
import 'package:dosprav/providers/view_models_provider.dart';

class AccountScreen extends StatefulWidget {
  static const String routeName = "/account";
  static const String dailyListAsDefaultKey = "dailyListAsDefault";

  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? _downloadedPhotoUrl;
  String? _userName;
  String? _userEmail;

  bool _isLoading = false;
  bool _useDailyListAsDefault = false;

  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initFromFb();
  }

  Future<void> _initFromFb() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _downloadedPhotoUrl = FirebaseAuth.instance.currentUser?.photoURL;
      _userName = FirebaseAuth.instance.currentUser?.displayName;
      _userEmail = FirebaseAuth.instance.currentUser?.email;
      _useDailyListAsDefault =
          _prefs?.getBool(AccountScreen.dailyListAsDefaultKey) ?? false;
    });
  }

  Future<void> _pickAndSavePhoto() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;
      var pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 300,
      );
      if (pickedFile != null && uid != null) {
        var photoRef = FirebaseStorage.instance
            .ref()
            .child("account_photo")
            .child("$uid.jpg");
        File fileToSave = File(pickedFile.path);
        await photoRef.putFile(fileToSave);
        var downloadedPhotoUrl = await photoRef.getDownloadURL();
        await FirebaseAuth.instance.currentUser
            ?.updatePhotoURL(downloadedPhotoUrl);

        setState(() {
          _downloadedPhotoUrl = downloadedPhotoUrl;
        });
      }
    } catch (error, stackTrace) {
      print("${error.toString()}\n${stackTrace.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cannot update your account photo. Please try again later.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearHome() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<HomeSlotsProvider>(context, listen: false).clearHome();
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cannot clear Home. Please try again later.",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Now you can compose your Home from scratch.",
            ),
          ),
        );
      }
    }
  }

  void _logout(BuildContext context) {
    Provider.of<CategoriesProvider>(context, listen: false).clear();
    Provider.of<TasksProvider>(context, listen: false).clear();
    Provider.of<CalendarGoalsProvider>(context, listen: false).clear();
    Provider.of<CalendarGoalTracksProvider>(context, listen: false).clear();
    Provider.of<HomeSlotsProvider>(context, listen: false).clear();
    Provider.of<ViewModelsProvider>(context, listen: false).clear();

    FirebaseAuth.instance.signOut();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var isHomeNotEmpty =
        Provider.of<HomeSlotsProvider>(context).items.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickAndSavePhoto,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundImage: _downloadedPhotoUrl != null
                                  ? NetworkImage(_downloadedPhotoUrl!)
                                  : null,
                            ),
                          ),
                          TextButton(
                            onPressed: _pickAndSavePhoto,
                            child: Text("Edit"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _userName ?? "",
                            style: TextStyle(
                              fontSize: 20,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AccountNameCompose(
                                      userName: _userName ?? "");
                                }).then((_) => setState(() {
                                  _userName = FirebaseAuth
                                      .instance.currentUser?.displayName;
                                }));
                          },
                          child: Text("Change Name"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _userEmail ?? "",
                            style: TextStyle(
                              fontSize: 20,
                              overflow: TextOverflow.ellipsis,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: null,
                          child: Text("Change Email"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: isHomeNotEmpty ? _clearHome : null,
                                child: Text("CLEAR HOME"),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () => _logout(context),
                                child: Text("SIGN OUT"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      height: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily List as default:",
                          style: TextStyle(
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Switch(
                          value: _useDailyListAsDefault,
                          onChanged: (bool value) {
                            setState(() {
                              _useDailyListAsDefault = value;
                              _prefs?.setBool(
                                  AccountScreen.dailyListAsDefaultKey, value);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
