// @dart=2.9
import 'dart:io';
import 'package:afcvn/News.dart';
import 'package:afcvn/Schedule.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:afcvn/Model/TeamData.dart';
import 'package:afcvn/Model/Scheduler_data.dart';
import 'package:afcvn/Standing.dart';

import 'Result.dart';
import 'getdata.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Liquorie',
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
    Text('Favourites'),
    Text('Favourites'),
  ];

  @override
  void initState() {
    super.initState();
    print(list_schedule);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'Newsss'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: 'Video'),
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
