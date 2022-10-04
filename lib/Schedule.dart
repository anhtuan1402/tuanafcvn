// @dart=2.9
import 'dart:convert';
import 'package:afcvn/Model/Scheduler_data.dart';
import 'package:afcvn/getdata.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<Response_Scheduler> list_scheduler;

Future<List<Response_Scheduler>> readJson_scheduler() async {
  if (list_scheduler != null) return list_scheduler;
  var headers = {
    'x-rapidapi-key': '5a50f7fb113c8fe8ba1e6615e3ba32ab',
    'x-rapidapi-host': 'v3.football.api-sports.io'
  };
  var link = 'https://v3.football.api-sports.io/fixtures?team=42&next=10';
  final response = await http.get(Uri.parse(link), headers: headers);
  if (response.statusCode == 200) {
    final res = json.decode(response.body)['response'];
    list_scheduler = List<Response_Scheduler>.from(res.map<Response_Scheduler>(
        (dynamic i) => Response_Scheduler.fromJson(i)));
    return list_scheduler;
  }
  return null;
}

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readJson_scheduler(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || list_scheduler == null) {
            return Center(child: CircularProgressIndicator());
          } else
            return Container(child: list_ne(list_scheduler));
        });
  }

  Widget list_ne(List<Response_Scheduler> list_scheduler) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: list_scheduler.length,
        itemBuilder: (BuildContext, index) {
          return Card(
              margin: EdgeInsets.all(10),
              color: Colors.green[100],
              shadowColor: Colors.blueGrey,
              elevation: 10,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 30, // 20%
                    child: Column(
                      children: [
                        Text(list_scheduler[index].fixture.date.substring(0, 10).toString()),
                        Text(""),
                        Text(list_scheduler[index].fixture.date.substring(11, 16).toString())
                      ],
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 60, // 60%
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Image.network(
                              list_scheduler[index].teams.home.logo,
                              width: 30,
                              height: 30,
                            )),
                            Text(list_scheduler[index].teams.home.name, textAlign: TextAlign.center)
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Image.network(
                              list_scheduler[index].teams.away.logo,
                              width: 30,
                              height: 30,
                            )),
                            Text(list_scheduler[index].teams.away.name, textAlign: TextAlign.center)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 40, // 20%
                    child: Column(
                      children: [
                        Text(""),
                        Row(
                          children: [
                            Image.network(
                              list_scheduler[index].league.logo,
                              width: 40,
                              height: 40,
                            ),
                            //Text(list_scheduler[index].league.name),
                          ],
                        ),
                        Text("")
                      ],
                    ),
                  )
                ],
              ));
        });
  }
}
