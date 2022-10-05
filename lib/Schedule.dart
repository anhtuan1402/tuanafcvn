// @dart=2.9
import 'dart:convert';

import 'package:afcvn/Model/Scheduler_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<Response_Scheduler> list_scheduler;

// Future<List<Response_Scheduler>> readJson_scheduler() async {
//   if (list_scheduler != null) return list_scheduler;
//   var headers = {'x-rapidapi-key': '5a50f7fb113c8fe8ba1e6615e3ba32ab', 'x-rapidapi-host': 'v3.football.api-sports.io'};
//   var link = 'https://v3.football.api-sports.io/fixtures?team=42&next=10';
//   final response = await http.get(Uri.parse(link), headers: headers);
//   print(response.body);
//   if (response.statusCode == 200) {
//     final res = json.decode(response.body)['response'];
//     list_scheduler =
//         List<Response_Scheduler>.from(res.map<Response_Scheduler>((dynamic i) => Response_Scheduler.fromJson(i)));
//     return list_scheduler;
//   }
//   return null;
// }

Future<List<Response_Scheduler>> readJson_scheduler_local() async {
  if (list_scheduler != null) return list_scheduler;
  final String response = await rootBundle.loadString('assets/scheduler.json');
  final data = await json.decode(response)['response'];
  //print(data);
  list_scheduler = List<Response_Scheduler>.from(data
      .map<Response_Scheduler>((dynamic i) => Response_Scheduler.fromJson(i)));
  return list_scheduler;
}

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readJson_scheduler_local(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || list_scheduler == null) {
            return Center(child: CircularProgressIndicator());
          } else
            return PageBody(snapshot.data);
          // return Container(child: list_ne(list_scheduler));
        });
  }

  // Widget list_ne(List<Response_Scheduler> list_scheduler) {
  //   return ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: list_scheduler.length,
  //       itemBuilder: (BuildContext, index) {
  //         return Card(
  //             margin: EdgeInsets.all(10),
  //             color: Colors.green[100],
  //             shadowColor: Colors.blueGrey,
  //             elevation: 10,
  //             child: Row(
  //               children: <Widget>[
  //                 Expanded(
  //                   flex: 30, // 20%
  //                   child: Column(
  //                     children: [
  //                       Text(list_scheduler[index].fixture.date.substring(0, 10).toString()),
  //                       Text(""),
  //                       Text(list_scheduler[index].fixture.date.substring(11, 16).toString())
  //                     ],
  //                   ),
  //                 ),
  //                 Spacer(),
  //                 Expanded(
  //                   flex: 60, // 60%
  //                   child: Column(
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Expanded(
  //                               child: Image.network(
  //                             list_scheduler[index].teams.home.logo,
  //                             width: 30,
  //                             height: 30,
  //                           )),
  //                           Text(list_scheduler[index].teams.home.name, textAlign: TextAlign.center)
  //                         ],
  //                       ),
  //                       Row(
  //                         children: [
  //                           Expanded(
  //                               child: Image.network(
  //                             list_scheduler[index].teams.away.logo,
  //                             width: 30,
  //                             height: 30,
  //                           )),
  //                           Text(list_scheduler[index].teams.away.name, textAlign: TextAlign.center)
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 40, // 20%
  //                   child: Column(
  //                     children: [
  //                       Text(""),
  //                       Row(
  //                         children: [
  //                           Image.network(
  //                             list_scheduler[index].league.logo,
  //                             width: 40,
  //                             height: 40,
  //                           ),
  //                           //Text(list_scheduler[index].league.name),
  //                         ],
  //                       ),
  //                       Text("")
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ));
  //       });
  // }

  Widget PageBody(List<Response_Scheduler> allmatches) {
    return Column(
      children: [
        Container(color: Color(0xFF4373D9), child: Text("11111111")),
        Expanded(
          flex: 2,
          child: Container(
            color: Color(0xFF4373D9),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  teamStat("", allmatches[0].teams.home.logo,
                      allmatches[0].teams.home.name),
                  goalStat(allmatches[0].fixture.timestamp, 0, 0,
                      allmatches[0].fixture.venue.name),
                  teamStat("", allmatches[0].teams.away.logo,
                      allmatches[0].teams.away.name),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF4373D9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "MATCHES",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allmatches.length,
                      itemBuilder: (context, index) {
                        return matchTile(allmatches[index]);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget teamStat(String team, String logoUrl, String teamName) {
    return Expanded(
      child: Column(
        children: [
          Text(
            team,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white,
              child: Image.network(
                logoUrl,
                width: 54.0,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            teamName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget matchTile(Response_Scheduler match) {
    var homeGoal = 0;
    var awayGoal = 0;
    if (homeGoal == null) homeGoal = 0;
    if (awayGoal == null) awayGoal = 0;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              match.teams.home.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          Image.network(
            match.teams.home.logo,
            width: 36.0,
          ),
          Expanded(
            child: Text(
              "${homeGoal} - ${awayGoal}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          Image.network(
            match.teams.away.logo,
            width: 36.0,
          ),
          Expanded(
            child: Text(
              match.teams.away.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget goalStat(
      int expandedTime, int homeGoal, int awayGoal, String location) {
    var home = homeGoal;
    var away = awayGoal;
    var elapsed = expandedTime;
    if (home == null) home = 0;
    if (away == null) away = 0;
    if (elapsed == null) elapsed = 0;
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
                    "${home} - ${away}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36.0,
                    ),
                  ),
                  Text(location)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
