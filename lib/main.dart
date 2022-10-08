// @dart=2.9
import 'dart:io';
import 'package:afcvn/News.dart';
import 'package:afcvn/Schedule.dart';
import 'package:afcvn/Video.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:afcvn/Model/TeamData.dart';
import 'package:afcvn/Model/Scheduler_data.dart';
import 'package:afcvn/Standing.dart';
import 'package:flutter/scheduler.dart';

import 'Result.dart';
import 'getdata.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Response_Scheduler> list_schedule;
  final widgetOptions = [
    News(),
    init_tab_bar_view(),
    Video(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 50,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/News.png')),label: "Tin tức"),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/football.png')),label: "Lịch thi đấu"),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/Videos.png')),label: "Video"),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.red[900],
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

Widget init_tab_bar_view() {
  return DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Lịch thi đấu",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        bottom: ButtonsTabBar(
          radius: 25,
          backgroundColor: Colors.red,
          unselectedBackgroundColor: Colors.white,
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(
              child: Text(
                "Lịch thi đấu",
                style: TextStyle(fontFamily: "Roboto", color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                "Kết quả",
                style: TextStyle(fontFamily: "Roboto", color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                "Bảng xếp hạng",
                style: TextStyle(fontFamily: "Roboto", color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(children: [Schedule(), Result(), Standing1()]),
    ),
  );
}
