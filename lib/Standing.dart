import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'Model/TeamData.dart';

var list_team;

Future<List<Standing>> readListTeam() async {
  if (list_team != null) return list_team;
  var headers = {
    'x-rapidapi-key': '5a50f7fb113c8fe8ba1e6615e3ba32ab',
    'x-rapidapi-host': 'v3.football.api-sports.io'
  };
  var link =
      'https://v3.football.api-sports.io/standings?season=2022&league=39';
  final response = await http.get(Uri.parse(link), headers: headers);
  print(response.body);
  if (response.statusCode == 200) {
    final res =
        json.decode(response.body)['response'][0]['league']['standings'][0];
    list_team = List<Standing>.from(
        res.map<Standing>((dynamic i) => Standing.fromJson(i)));
    return list_team;
  }
  return null;
}

Future<List<Standing>> readListTeam_local() async {
  if (list_team != null) return list_team;
  final String response = await rootBundle.loadString('assets/js.json');
  final res =
      await json.decode(response)['response'][0]['league']['standings'][0];
  list_team = List<Standing>.from(
      res.map<Standing>((dynamic i) => Standing.fromJson(i)));
  return list_team;
}

class Standing1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 2, child: TopRow()),
        Expanded(
          flex: 20,
          child: FutureBuilder(
              future: readListTeam(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData || list_team == null) {
                  return const Center(child: CircularProgressIndicator());
                } else
                  return PageBody(snapshot.data, context);
                // return Container(child: list_ne(list_scheduler));
              }),
        ),
      ],
    );
  }

  Widget PageBody(List<Standing> list_data_team, BuildContext context) {
    return Container(
      //Color.fromRGBO(235, 241, 252, 0.5)
      color: Theme.of(context)
          .backgroundColor
          .withGreen(235)
          .withGreen(241)
          .withBlue(252)
          .withOpacity(0.5),
      child: Expanded(
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
          itemCount: list_data_team.length,
          itemBuilder: (context, index) {
            return matchTile(list_data_team[index]);
          },
        ),
      ),
    );
  }

  Widget matchTile(Standing data_team) {
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Container(
            padding: EdgeInsets.all(10.0),
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

class TopRow extends StatelessWidget {
  const TopRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
    TextStyle textStyle2 = TextStyle(fontSize: 13);

    return Container(
      color: Theme.of(context)
          .backgroundColor
          .withGreen(235)
          .withGreen(241)
          .withBlue(252)
          .withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              flex: 1,
              child: Text('#'),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Đội',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(""),
            ),
            Expanded(
              flex: 2,
              child: Text("Trận"),
            ),
            Expanded(
              flex: 2,
              child: Text("HS"),
            ),
            Expanded(
              flex: 2,
              child: Text("Điểm"),
            ),
          ],
        ),
      ),
    );
  }
}
