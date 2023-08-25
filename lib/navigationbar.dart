import 'package:abc_2_1/addadmin.dart';
import 'package:abc_2_1/admin/home.dart';
import 'package:abc_2_1/detail.dart';
import 'package:abc_2_1/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navigationbar extends StatefulWidget {
  Navigationbar({Key? key}) : super(key: key);

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  late SharedPreferences prefs;
  var usertype = 0;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      usertype = prefs.getInt('type')!.toInt();
    });
  }

  int myIndex = 0;
  List<Widget> widgetList = [
    Homepag(),
    Detail(),
    AddAdmin(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetList[myIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Detail',
            ),
            if (usertype == 2)
              BottomNavigationBarItem(
                icon: Icon(Icons.person_add),
                label: 'Admin',
              ),
          ]),
    );
  }
}
