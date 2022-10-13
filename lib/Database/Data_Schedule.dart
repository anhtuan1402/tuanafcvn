import 'dart:convert';

import 'package:afcvn/Model/Scheduler_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

int count_request = 0;

Future<List<Response_Scheduler>> readJson_scheduler() async {
  List<Response_Scheduler> listScheduler;
  final prefs = await SharedPreferences.getInstance();
  String jsonString = prefs.getString("json_scheduler");
  if (jsonString != null) {
    final res = json.decode(jsonString)['response'];
    listScheduler = List<Response_Scheduler>.from(res.map<Response_Scheduler>(
        (dynamic i) => Response_Scheduler.fromJson(i)));
    return listScheduler;
  } else {
    if (count_request > 1) {
      return listScheduler;
    }
    api_readJson_scheduler();

    return readJson_scheduler();
  }
}

Future<void> api_readJson_scheduler() async {
  count_request++;
  print("count api = $count_request");
  int sl = 20;
  if (count_request > 5) {
    sl = 40;
  }
  var headers = {
    'x-rapidapi-key': '5a50f7fb113c8fe8ba1e6615e3ba32ab',
    'x-rapidapi-host': 'v3.football.api-sports.io'
  };
  var link =
      'https://v3.football.api-sports.io/fixtures?team=42&next=$sl&timezone=Asia/Ho_Chi_Minh';

  final response = await http.get(Uri.parse(link), headers: headers);
  if (response.statusCode == 200 && response.body.contains("Arsenal")) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("json_scheduler", response.body.toString());
  }
}

Future<List<Response_Scheduler>> api_readJson_scheduler_first() async {
  final prefs = await SharedPreferences.getInstance();
  String jsonString = prefs.getString("json_scheduler");
  if (jsonString != null) {
    return readJson_scheduler();
  }
  List<Response_Scheduler> listScheduler;
  count_request++;
  print("count api = $count_request");
  int sl = 20;
  if (count_request > 5) {
    sl = 40;
  }
  var headers = {
    'x-rapidapi-key': '5a50f7fb113c8fe8ba1e6615e3ba32ab',
    'x-rapidapi-host': 'v3.football.api-sports.io'
  };
  var link =
      'https://v3.football.api-sports.io/fixtures?team=42&next=$sl&timezone=Asia/Ho_Chi_Minh';

  final response = await http.get(Uri.parse(link), headers: headers);
  if (response.statusCode == 200 && response.body.contains("Arsenal")) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("json_scheduler", response.body.toString());
    final res = json.decode(response.body)['response'];
    listScheduler = List<Response_Scheduler>.from(res.map<Response_Scheduler>(
        (dynamic i) => Response_Scheduler.fromJson(i)));
    return listScheduler;
  }
}
