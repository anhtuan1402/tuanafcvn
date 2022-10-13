// @dart=2.9

import 'package:afcvn/Database/Data_Schedule.dart';
import 'package:afcvn/Model/Scheduler_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key key}) : super(key: key);

  @override
  Schedule_state createState() => Schedule_state();
}

class Schedule_state extends State<Schedule> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  var prefs;
  var jsonString_scheduler;

  Future<dynamic> init_first() async {
    prefs = await SharedPreferences.getInstance();
    jsonString_scheduler = prefs.getString("json_scheduler");
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      api_readJson_scheduler();
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    init_first();
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      child: FutureBuilder(
          future: jsonString_scheduler == null
              ? api_readJson_scheduler_first()
              : readJson_scheduler(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return PageBody(snapshot.data);
            }
          }),
    );
  }

  Widget PageBody(List<Response_Scheduler> allmatches) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 241, 252, 0.5),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                height: 131,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(220, 47, 32, 1),
                  image: DecorationImage(
                    image: AssetImage('assets/back.png'),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, right: 16.0, left: 16.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      teamHome(
                          allmatches[0].fixture.date,
                          allmatches[0].teams.home.logo,
                          allmatches[0].teams.home.name),
                      goalStat(allmatches[0].fixture.date, 0, 0,
                          allmatches[0].fixture.venue.name),
                      teamAway(
                          allmatches[0].league.name,
                          allmatches[0].teams.away.logo,
                          allmatches[0].teams.away.name),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 0.0,
                ),
                child: ListView.builder(
                  itemCount: allmatches.length - 1,
                  itemBuilder: (context, index) {
                    return matchTile(allmatches[index + 1]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget teamHome(String date, String logoUrl, String teamName) {
    var elapsed =
        "${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)} ${date.substring(11, 16)}";
    return Expanded(
      child: Column(
        children: [
          Text(
            elapsed,
            style: const TextStyle(
                fontSize: 10, fontFamily: "Roboto", color: Colors.white),
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Image.network(
                logoUrl,
                width: 36.0,
                height: 36.0,
              ),
            ),
          ),
          Text(
            teamName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              //TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily:"Roboto")
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Roboto",
            ),
          ),
        ],
      ),
    );
  }

  Widget teamAway(String league, String logoUrl, String teamName) {
    return Expanded(
      child: Column(
        children: [
          Text(
            league,
            style: const TextStyle(
              fontSize: 10,
              fontFamily: "Roboto",
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Image.network(
                logoUrl,
                width: 36.0,
                height: 36.0,
              ),
            ),
          ),
          Text(
            teamName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              //TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily:"Roboto")
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              fontFamily: "Roboto",
            ),
          ),
        ],
      ),
    );
  }

  Widget matchTile(Response_Scheduler match) {
    var homeGoal = 0;
    var awayGoal = 0;
    homeGoal ??= 0;
    awayGoal ??= 0;
    var elapsed =
        "${match.fixture.date.substring(8, 10)}/${match.fixture.date.substring(5, 7)}/${match.fixture.date.substring(0, 4)}\n ${match.fixture.date.substring(11, 16)}";
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
              bottomLeft: Radius.circular(12.0),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: [
                    Time_List(elapsed: elapsed),
                    Expanded(
                      flex: 6,
                      child: Column(children: [
                        Row(
                          children: [
                            Image.network(
                              match.teams.home.logo,
                              width: 25.0,
                            ),
                            Text(" ${match.teams.home.name}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color.fromRGBO(10, 18, 32, 1),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto",
                                  fontSize: 14.0,
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Image.network(
                              match.teams.away.logo,
                              width: 25.0,
                            ),
                            Text(" ${match.teams.away.name}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color.fromRGBO(10, 18, 32, 1),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto",
                                  fontSize: 14.0,
                                ))
                          ],
                        ),
                      ]),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        match.league.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color.fromRGBO(10, 18, 32, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget goalStat(String date, int homeGoal, int awayGoal, String location) {
    TextStyle textStyle2 = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(255, 255, 255, 1),
    );
    var home = homeGoal;
    var away = awayGoal;
    home ??= 0;
    away ??= 0;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$home - $away",
                    textAlign: TextAlign.center,
                    style: textStyle2,
                  ),
                  Text(
                    location,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto",
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Time_List extends StatelessWidget {
  const Time_List({
    Key key,
    @required this.elapsed,
  }) : super(key: key);

  final String elapsed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Text(
        elapsed,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color.fromRGBO(10, 18, 32, 1),
          fontSize: 12.0,
        ),
      ),
    );
  }
}
