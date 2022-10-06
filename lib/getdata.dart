import 'dart:convert';
import 'dart:io';

import 'package:afcvn/Model/News_Data.dart';
import 'package:afcvn/Model/TeamData.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<void> readJson(List<Standing> list_team) async {
  if (list_team != null) return;
  final String response = await rootBundle.loadString('assets/js.json');
  final res =
      await json.decode(response)['response'][0]['league']['standings'][0];
  list_team = List<Standing>.from(
      res.map<Standing>((dynamic i) => Standing.fromJson(i)));
}

Future<void> readJsonNews() async {
  List<Data_News> list_data;
  var link = 'https://api.afcvn.host/v1/news/GetNews';
  Map data = {'PageIndex': 1, 'PageSize': 1, 'SearchValue': ''};
  var bodyString = json.encode(data);
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

  final response =
      await http.post(Uri.parse(link), headers: headers, body: bodyString);
  if (response.statusCode == 200) {
    final res = json.decode(response.body)['Data'];
    list_data = List<Data_News>.from(
        res.map<Data_News>((dynamic i) => Data_News.fromJson(i)));
  }
}


List<Standing> list_team;

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
