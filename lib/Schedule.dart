// @dart=2.9
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:afcvn/Model/Scheduler_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<Response_Scheduler> list_scheduler;

Future<List<Response_Scheduler>> readJson_scheduler() async {
  if (list_scheduler != null) return list_scheduler;
  var headers = {'x-rapidapi-key': '5a50f7fb113c8fe8ba1e6615e3ba32ab', 'x-rapidapi-host': 'v3.football.api-sports.io'};
  var link = 'https://v3.football.api-sports.io/fixtures?team=42&next=20';
  final response = await http.get(Uri.parse(link), headers: headers);
  print(response.body);
  if (response.statusCode == 200) {
    final res = json.decode(response.body)['response'];
    list_scheduler =
        List<Response_Scheduler>.from(res.map<Response_Scheduler>((dynamic i) => Response_Scheduler.fromJson(i)));
    return list_scheduler;
  }
  return null;
}

Future<List<Response_Scheduler>> readJson_scheduler_local() async {
  // if (list_scheduler != null) return list_scheduler;
  // final String response = await rootBundle.loadString('assets/scheduler.json');
  // final data = await json.decode(response)['response'];
  // //print(data);
  // list_scheduler = List<Response_Scheduler>.from(data
  //     .map<Response_Scheduler>((dynamic i) => Response_Scheduler.fromJson(i)));
  return readJson_scheduler();
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
  // decoration: BoxDecoration(
  // color: Color(0xFF4373D9),
  // borderRadius: BorderRadius.only(
  // topLeft: Radius.circular(40.0),
  // topRight: Radius.circular(40.0),
  // ),
  // ),
  Widget PageBody(List<Response_Scheduler> allmatches) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 241, 252, 0.5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                height: 131,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(220, 47, 32, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0,bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      teamStat("", allmatches[0].teams.home.logo,
                          allmatches[0].teams.home.name),
                      goalStat(allmatches[0].fixture.date, 0, 0,
                          allmatches[0].fixture.venue.name),
                      teamStat("", allmatches[0].teams.away.logo,
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
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "MATCHES",
                        style: TextStyle(
                          color:Color.fromRGBO(10,18,32, 1),
                          fontSize: 24.0,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: allmatches.length-1,
                          itemBuilder: (context, index) {
                            return matchTile(allmatches[index+1]);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget teamStat(String team, String logoUrl, String teamName) {
    return Expanded(
      child: Column(
        children: [
          Text(
            team,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily:"Roboto"),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Colors.white,
              child: Image.network(
                logoUrl,
                width: 36.0,
                height: 36.0,
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            teamName,
            textAlign: TextAlign.center,
            style: const TextStyle(
                //TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily:"Roboto")
              color: Color.fromRGBO(255, 255, 255, 1),
              fontSize: 18.0,
              fontStyle: FontStyle.normal,
              fontFamily:"Roboto",

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
    var elapsed = "${match.fixture.date.substring(8,10)}/${match.fixture.date.substring(5,7)}/${match.fixture.date.substring(0,4)}\n ${match.fixture.date.substring(11,16)}";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              match.teams.home.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:Color.fromRGBO(10,18,32, 1),
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
              elapsed,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:Color.fromRGBO(10,18,32, 1),
                fontSize: 12.0,
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
              style: const TextStyle(
                color:Color.fromRGBO(10,18,32, 1),
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget goalStat(
      String date, int homeGoal, int awayGoal, String location) {
    TextStyle textStyle2 = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily:"Roboto", color: Color.fromRGBO(255, 255, 255, 1),);
    var home = homeGoal;
    var away = awayGoal;
    var elapsed = "${date.substring(8,10)}/${date.substring(5,7)}/${date.substring(0,4)} ${date.substring(11,16)}";
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

                  Text(elapsed,style: const TextStyle(
                    color: Colors.white70,
                      fontFamily: "Roboto"
                  ),),
                  Text(
                    "$home - $away",
                    textAlign: TextAlign.center,
                    style: textStyle2,
                  ),
                  Text(location,style: const TextStyle(
                    color: Colors.white70,
                      fontFamily: "Roboto",
                  ),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
