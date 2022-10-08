import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'Model/Scheduler_data.dart';
import 'Model/TeamData.dart';

List<Standing> list_team;

Future<List<Standing>> readListTeam() async {
  if (list_team != null) return list_team;
  var headers = {'x-rapidapi-key': 'b5099d3abbea854bcad579a664eb8a79', 'x-rapidapi-host': 'v3.football.api-sports.io'};
  var link = 'https://v3.football.api-sports.io/standings?season=2022&league=39';
  final response = await http.get(Uri.parse(link), headers: headers);
  if (response.statusCode == 200) {
    final res = json.decode(response.body)['response'][0]['league']['standings'][0];
    list_team = List<Standing>.from(res.map<Standing>((dynamic i) => Standing.fromJson(i)));
    return list_team;
  }
  return null;
}

Future<List<Standing>> readListTeam_local() async {
  if (list_team != null) return list_team;
  final String response = await rootBundle.loadString('assets/js.json');

  final res = await json.decode(response)['response'][0]['league']['standings'][0];
  list_team = List<Standing>.from(res.map<Standing>((dynamic i) => Standing.fromJson(i)));
  return list_team;
}

class Standing1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(235, 241, 252, 0.5),
      child: FutureBuilder(
          future: readListTeam_local(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData || list_team == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return PageBody(snapshot.data, context);
            }
            // return Container(child: list_ne(list_scheduler));
          }),
    );
  }

  Widget PageBody(List<Standing> allmatches, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      itemCount: allmatches.length,
      itemBuilder: (context, index) {
        return matchTile(allmatches[index], context);
      },
    );
  }

  Widget matchTile(Standing data_team, BuildContext context) {
    return data_team.rank == 1
        ? Column(
            children: [
              Top_Row(context),
              const SizedBox(
                height: 4.0,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: data_team.team.id == 42
                      ? const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                          ),
                        )
                      : const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                          ),
                        ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            data_team.rank.toString(),
                            textAlign: TextAlign.center,
                          )),
                      Expanded(
                        flex: 2,
                        child: Image.network(
                          data_team.team.logo,
                          width: 25.0,
                          height: 25.0,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          data_team.team.name,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data_team.all.played.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data_team.goalsDiff.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data_team.points.toString(),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )),
            ],
          )
        : Column(
            children: [
              const SizedBox(
                height: 4.0,
              ),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  decoration: data_team.team.id == 42
                      ? const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                          ),
                        )
                      : const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                          ),
                        ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            data_team.rank.toString(),
                            textAlign: TextAlign.center,
                          )),
                      Expanded(
                        flex: 2,
                        child: Image.network(
                          data_team.team.logo,
                          width: 25.0,
                          height: 25.0,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          data_team.team.name,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data_team.all.played.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data_team.goalsDiff.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data_team.points.toString(),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )),
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

Widget Top_Row(BuildContext context) {
  TextStyle textStyle = const TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
  TextStyle textStyle2 = const TextStyle(fontSize: 13);

  return Container(
    color: Theme.of(context).backgroundColor.withGreen(235).withGreen(241).withBlue(252).withOpacity(0.5),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: const [
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            flex: 1,
            child: Text('#', style: TextStyle(
              color: Color.fromRGBO(20, 56, 114, 1),
            ),),
          ),
          Expanded(
            flex: 2,
            child: Text(""),
          ),
          Expanded(
            flex: 6,
            child: Text(
              'Đội',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(20, 56, 114, 1),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text("Trận", textAlign: TextAlign.center, style: TextStyle(
              color: Color.fromRGBO(20, 56, 114, 1),
            ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text("HS", textAlign: TextAlign.center, style: TextStyle(
              color: Color.fromRGBO(20, 56, 114, 1),
            ),),
          ),
          Expanded(
            flex: 2,
            child: Text("Điểm", textAlign: TextAlign.center, style: TextStyle(
              color: Color.fromRGBO(20, 56, 114, 1),
            ),),
          ),
        ],
      ),
    ),
  );
}
