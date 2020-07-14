import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:petshopowner/Classes/Constants.dart';
import 'package:petshopowner/Pages/IssuesPage.dart';
import 'package:petshopowner/Pages/PastOrders.dart';

import 'Pages/DeletePet.dart';
import 'Pages/Orders.dart';
import 'Pages/RegisterPet.dart';
import 'Pages/UpdatePet.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Shop Owner',
      home: MyStatefulWidget(),
    );
  }
}

void showToast(message, Color color) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: color,
    textColor: Color(0xFF345995),
    fontSize: 16.0,
  );
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  String task = 'Register New Product';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Row(
          children: <Widget>[
            NavigationRail(
              backgroundColor: kPrimaryColor,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                  if (_selectedIndex == 0) task = 'Register New Product';
                  if (_selectedIndex == 1) task = 'Update Product';
                  if (_selectedIndex == 2) task = 'Delete';
                  if (_selectedIndex == 3) task = 'Current Orders';
                  if (_selectedIndex == 4) task = 'Past Orders';
                  if (_selectedIndex == 5) task = 'Complaints';
                });
              },
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(
                    Icons.fiber_new,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.fiber_new,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'New',
                    style: TextStyle(fontFamily: 'Cabin', color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.system_update_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.system_update_alt,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'Update',
                    style: TextStyle(fontFamily: 'Cabin', color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'Delete',
                    style: TextStyle(fontFamily: 'Cabin', color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.watch_later,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.watch_later,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'Pending\nOrders',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Cabin', color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'Completed\nOrders',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Cabin', color: Colors.white),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 30,
                  ),
                  selectedIcon: Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: Text(
                    'Complaints',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            VerticalDivider(thickness: 1, width: 1),
            // This is the main content.
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Pet Shop",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                          fontFamily: 'Cabin',
                          color: kPrimaryColor,
                        )),
                    Text("Owner Console",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                          fontFamily: 'Cabin',
                          color: kPrimaryColor,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      task,
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 28,
                        fontFamily: 'Cabin',
                        color: kPrimaryColor,
                      ),
                    ),
                    if (_selectedIndex == 0)
                      RegisterPet()
                    else if (_selectedIndex == 1)
                      UpdatePet()
                    else if (_selectedIndex == 2)
                      Delete()
                    else if (_selectedIndex == 3)
                      Orders()
                    else if (_selectedIndex == 4)
                      PastOrders()
                    else if (_selectedIndex == 5)
                      IssuesPage()
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
