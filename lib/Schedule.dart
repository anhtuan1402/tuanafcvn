// @dart=2.9
import 'dart:convert';

import 'package:afcvn/Model/Scheduler_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

List<Response_Scheduler> list_scheduler;

Future<List<Response_Scheduler>> readJson_scheduler() async {
  if (list_scheduler != null) return list_scheduler;
  var headers = {'x-rapidapi-key': 'b5099d3abbea854bcad579a664eb8a79', 'x-rapidapi-host': 'v3.football.api-sports.io'};
  var link = 'https://v3.football.api-sports.io/fixtures?team=42&next=20&timezone=Asia/Ho_Chi_Minh';
  final response = await http.get(Uri.parse(link), headers: headers);
  if (response.statusCode == 200) {
    final res = json.decode(response.body)['response'];

    list_scheduler =
        List<Response_Scheduler>.from(res.map<Response_Scheduler>((dynamic i) => Response_Scheduler.fromJson(i)));
    return list_scheduler;
  }
  return null;
}

Future<List<Response_Scheduler>> readJson_scheduler_local() async {
  if (list_scheduler != null) return list_scheduler;
  final String response = await rootBundle.loadString('assets/scheduler.json');
  final data = await json.decode(response)['response'];
  //print(data);
  list_scheduler =
      List<Response_Scheduler>.from(data.map<Response_Scheduler>((dynamic i) => Response_Scheduler.fromJson(i)));
  return list_scheduler;
}

class Schedule extends StatelessWidget {
  const Schedule({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readJson_scheduler_local(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || list_scheduler == null) {
            return const Center(child: CircularProgressIndicator());
          } else
            return PageBody(snapshot.data);
          // return Container(child: list_ne(list_scheduler));
        });
  }

  Widget PageBody(List<Response_Scheduler> allmatches) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 241, 252, 0.5),
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
                    image: AssetImage(
                        'assets/back.png'),
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
                  padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      teamHome(allmatches[0].fixture.date, allmatches[0].teams.home.logo, allmatches[0].teams.home.name),
                      goalStat(allmatches[0].fixture.date, 0, 0, allmatches[0].fixture.venue.name),
                      teamAway(allmatches[0].league.name, allmatches[0].teams.away.logo, allmatches[0].teams.away.name),
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
                  itemCount: allmatches.length-1,
                  itemBuilder: (context, index) {
                    return matchTile(allmatches[index+1]);
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
            style: const TextStyle(fontSize: 10, fontFamily: "Roboto",color: Colors.white),
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
            style: const TextStyle(fontSize: 10, fontFamily: "Roboto",color: Colors.white, fontWeight: FontWeight.w400,),
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
                                )
                            )
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
    var elapsed = "${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)} ${date.substring(11, 16)}";
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
