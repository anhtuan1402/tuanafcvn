import 'dart:convert';

import 'package:afcvn/Model/Scheduler_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

int count_request = 0;

Future<List<Response_Scheduler>> readJson_scheduler_result() async {
  List<Response_Scheduler> listSchedulerResult;
  final prefs = await SharedPreferences.getInstance();
  String jsonString = prefs.getString("json_schedule_result");
  print("readJson_scheduler_result1111111111 = ${jsonString}");
  if (jsonString != null) {
    final res = json.decode(jsonString)['response'];
    listSchedulerResult = List<Response_Scheduler>.from(
        res.map<Response_Scheduler>(
            (dynamic i) => Response_Scheduler.fromJson(i)));
    return listSchedulerResult;
  } else {
    if (count_request > 1) {
      return listSchedulerResult;
    }
    api_readJson_scheduler_result();
    return readJson_scheduler_result();
  }
}

Future<void> api_readJson_scheduler_result() async {
  count_request++;
  int sl = 5;
  if (count_request > 5) {
    sl = 40;
  }
  var headers = {
    'x-rapidapi-key': '5a50f7fb113c8fe8ba1e6615e3ba32ab',
    'x-rapidapi-host': 'v3.football.api-sports.io'
  };
  var link =
      'https://v3.football.api-sports.io/fixtures?team=42&last=$sl&timezone=Asia/Ho_Chi_Minh';

  final response = await http.get(Uri.parse(link), headers: headers);
  print("api_readJson_scheduler_result = ${response.statusCode}");
  if (response.statusCode == 200 && response.body.contains("Arsenal")) {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("json_schedule_result", response.body);
    print(
        "get api_readJson_scheduler_result = ${prefs.getString("json_schedule_result")}");
  }
}
