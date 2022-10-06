import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'Model/Scheduler_data.dart';

List<Response_Scheduler> list_scheduler;

Future<List<Response_Scheduler>> readJson_scheduler() async {
  if (list_scheduler != null) return list_scheduler;
  //b5099d3abbea854bcad579a664eb8a79
  //5a50f7fb113c8fe8ba1e6615e3ba32ab
  var headers = {'x-rapidapi-key': 'b5099d3abbea854bcad579a664eb8a79', 'x-rapidapi-host': 'v3.football.api-sports.io'};
  var link = 'https://v3.football.api-sports.io/fixtures?team=42&last=20&timezone=Asia/Ho_Chi_Minh';
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

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readJson_scheduler_local(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || list_scheduler == null) {
            return const Center(child: CircularProgressIndicator());
          } else
            return PageBody(snapshot.data, context);
          // return Container(child: list_ne(list_scheduler));
        });
  }

  Widget PageBody(List<Response_Scheduler> allmatches, BuildContext context) {
    return Container(
      //Color.fromRGBO(235, 241, 252, 0.5)
      color: Theme.of(context).backgroundColor.withGreen(235).withGreen(241).withBlue(252).withOpacity(0.5),
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
        itemCount: allmatches.length,
        itemBuilder: (context, index) {
          return matchTile(allmatches[index]);
        },
      ),
    );
  }

  Widget matchTile(Response_Scheduler match) {
    String homeGoal = match.goals.home == null ? "" : match.goals.home.toString();
    String awayGoal = match.goals.away == null ? "" : match.goals.away.toString();
    bool is_home = match.teams.home.id == 42;
    bool is_away = match.teams.away.id == 42;

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
                    Time_List(match.fixture.status.short),
                    Expanded(
                      flex: 20,
                      child: Column(children: [
                        Row(
                          children: [
                            Image.network(
                              match.teams.home.logo,
                              width: 25.0,
                            ),
                            Text(" ${match.teams.home.name}",
                                textAlign: TextAlign.center,
                                style: is_home
                                    ? const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      )
                                    : const TextStyle(
                                        color: Color.fromRGBO(10, 18, 32, 1),
                                        fontWeight: FontWeight.bold,
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
                                style: is_away
                                    ? const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      )
                                    : const TextStyle(
                                        color: Color.fromRGBO(10, 18, 32, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ))
                          ],
                        ),
                      ]),
                    ),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              homeGoal,
                              textAlign: TextAlign.center,
                              style: is_home
                                  ? const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    )
                                  : TextStyle(
                                      color: Color.fromRGBO(10, 18, 32, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              awayGoal,
                              textAlign: TextAlign.center,
                              style: is_away
                                  ? const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    )
                                  : TextStyle(
                                      color: Color.fromRGBO(10, 18, 32, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget Time_List(String status) {
  return Expanded(
    flex: 3,
    child: Text(
      status,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color.fromRGBO(10, 18, 32, 1),
        fontSize: 12.0,
      ),
    ),
  );
}
