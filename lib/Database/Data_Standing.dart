import 'dart:convert';

import 'package:afcvn/Model/TeamData.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

int count_api = 0;

Future<List<Standing_model>> readListTeam() async {
  List<Standing_model> listTeam;
  final prefs = await SharedPreferences.getInstance();
  String jsonString = prefs.getString("json_standing");
  if (jsonString != null) {
    final res =
        json.decode(jsonString)['response'][0]['league']['standings'][0];
    listTeam = List<Standing_model>.from(
        res.map<Standing_model>((dynamic i) => Standing_model.fromJson(i)));
    return listTeam;
  } else {
    if (count_api > 1) return listTeam;
    api_readListTeam();
    return readListTeam();
  }
}

Future<void> api_readListTeam() async {
  count_api++;
  var headers = {
    'x-rapidapi-key': '5a50f7fb113c8fe8ba1e6615e3ba32ab',
    'x-rapidapi-host': 'v3.football.api-sports.io'
  };
  var link =
      'https://v3.football.api-sports.io/standings?season=2022&league=39';
  final response = await http.get(Uri.parse(link), headers: headers);
  if (response.statusCode == 200 && response.body.contains("Arsenal")) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("json_standing", response.body.toString());
  }
}

Future<List<Standing_model>> api_readListTeam_first() async {
  final prefs = await SharedPreferences.getInstance();
  String jsonString = prefs.getString("json_standing");
  if (jsonString != null) {
    return readListTeam();
  }
  List<Standing_model> listTeam;
  count_api++;
  var headers = {
    'x-rapidapi-key': '5a50f7fb113c8fe8ba1e6615e3ba32ab',
    'x-rapidapi-host': 'v3.football.api-sports.io'
  };
  var link =
      'https://v3.football.api-sports.io/standings?season=2022&league=39';
  final response = await http.get(Uri.parse(link), headers: headers);
  if (response.statusCode == 200 && response.body.contains("Arsenal")) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("json_standing", response.body.toString());
    final res =
        json.decode(response.body)['response'][0]['league']['standings'][0];
    listTeam = List<Standing_model>.from(
        res.map<Standing_model>((dynamic i) => Standing_model.fromJson(i)));
  }
  return listTeam;
}
