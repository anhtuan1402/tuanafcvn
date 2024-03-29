// @dart=2.9
import 'package:afcvn/Model/Scheduler_data.dart';
import 'package:afcvn/View/News.dart';
import 'package:afcvn/View/Result.dart';
import 'package:afcvn/View/Schedule.dart';
import 'package:afcvn/View/Standing.dart';
import 'package:afcvn/View/Video.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: SplashScreen(
          seconds: 3,
          navigateAfterSeconds: HomePage(),
          imageBackground: AssetImage("assets/Splash.png"),
        ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 1;
  List<Response_Scheduler> list_schedule;
  final widgetOptions = [
    const News(),
    init_tab_bar_view(),
    const Video(),
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
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Document.png')),
              label: "Tin tức"),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/football.png')),
              label: "Lịch thi đấu"),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/Play.png')), label: "Video"),
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabBar(
            splashBorderRadius: BorderRadius.all(Radius.circular(25)),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.red,
            ),
            labelStyle:
                TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            tabs: [
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
      ),
      body: const TabBarView(children: [Schedule(), Result(), Standing()]),
    ),
  );
}
