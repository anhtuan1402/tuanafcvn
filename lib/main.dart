// @dart=2.9
import 'dart:io';
import 'package:afcvn/News.dart';
import 'package:afcvn/Schedule.dart';
import 'package:flutter/material.dart';
import 'package:afcvn/Model/TeamData.dart';
import 'package:afcvn/Model/Scheduler_data.dart';
import 'package:afcvn/Standing.dart';

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
  ];

  @override
  void initState() {
    super.initState();
    print("chay respone");
    readJson_scheduler();
    print(list_schedule);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
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

init_tab_bar_view() {
  return DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Lịch thi đấu",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        bottom: const TabBar(
          tabs: [
            Tab(
              child: Text(
                "Lịch thi đấu",
                style: TextStyle(fontFamily: "BarlowBold", color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                "Kết quả",
                style: TextStyle(fontFamily: "BarlowBold", color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                "Bảng xếp hạng",
                style: TextStyle(fontFamily: "BarlowBold", color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(children: [Schedule(), Center(child: Text("Transit")), Standings()]),
    ),
  );
}
