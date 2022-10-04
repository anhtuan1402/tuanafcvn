// @dart=2.9
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:afcvn/Model/TeamData.dart';

List<Standing> list_team;
Future<List<Standing>> readJson() async {
  if (list_team != null) return list_team;
  var headers = {
    'x-rapidapi-key': '5a50f7fb113c8fe8ba1e6615e3ba32ab',
    'x-rapidapi-host': 'v3.football.api-sports.io'
  };
  var link =
      'https://v3.football.api-sports.io/standings?league=39&season=2022';
  final response = await http.get(Uri.parse(link), headers: headers);
  if (response.statusCode == 200) {
    final res =
        json.decode(response.body)['response'][0]['league']['standings'][0];
    list_team = List<Standing>.from(
        res.map<Standing>((dynamic i) => Standing.fromJson(i)));
    return list_team;
  }
  return null;
}

class Standings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TopRow(),
              FutureBuilder(
                  future: readJson(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else
                      return Container(child: list(list_team));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget list(List<Standing> list_team) {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: list_team.length,
    itemBuilder: (BuildContext, data) {
      return TableRow(
        clubs: list_team,
        index: data,
      );
    },
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
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 30,
            height: 30,
            child: Text('#'),
          ),
          SizedBox(width: 20),
          Container(alignment: Alignment.center, child: Text('Teams')),
          Spacer(),
          Container(
            width: 28,
            child: Text(
              'Trận',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 28,
            child: Text(
              'HS',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 28,
            child: Text(
              'Đ',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}

class TableRow extends StatelessWidget {
  final int index;
  final List<Standing> clubs;
  const TableRow({
    this.index,
    this.clubs,
    Key key,
  }) : super(key: key);
/////////////////////////////////////////////////////////////////////linkwell
  ////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    // TextStyle textStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
    TextStyle textStyle2 = TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 0.2),
        color: clubs[index].team.id == 42 ? Colors.yellow[100] : Colors.purpleAccent[20],
      ),
      child: Row(
        children: [
          Container(
            //iinkwell
            alignment: Alignment.center,
            width: 30,
            height: 40,
            color: index < 4
                ? Colors.blue
                : index == 2
                    ? Colors.red[400]
                    : index > 16
                        ? Colors.red[800]
                        : Colors.grey[700],
            child: Text(
              (index + 1).toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 20),
          Row(
            children: [
              Image.network(
                clubs[index].team.logo,
                width: 24.0,
                height: 24.0,
              ),
              SizedBox(width: 5.0),
              Text(
                clubs[index].team.name.toString(),
                style: textStyle2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Spacer(),
          Container(
            width: 28,
            child: Text(
              clubs[index].all.played.toString(),
              style: textStyle2,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 28,
            child: Text(
              (clubs[index].goalsDiff).toString(),
              style: textStyle2,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 28,
            child: Text(
              clubs[index].points.toString(),
              style: textStyle2,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
