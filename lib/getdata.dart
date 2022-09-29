import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:afcvn/Model/TeamData.dart';
import 'package:afcvn/Model/Scheduler_data.dart';

// Future<List<TeamData_Standing>> fetchPost() async {
//   print("1111111111111");
//   var headers = {'x-rapidapi-key': '5a50f7fb113c8fe8ba1e6615e3ba32ab', 'x-rapidapi-host': 'v3.football.api-sports.io'};
//   var request = http.Request('GET', Uri.parse('https://v3.football.api-sports.io/standings?league=39&season=2022'));
//   request.headers.addAll(headers);
//   print("33333333333");
//
//   print("44444444");
//   //final response = await http.get(Uri.parse(Uri.parse(request)));
//
//   print("44444444 ${response.statusCode}");
//   if (response.statusCode == 200) {
//     final res = json.decode(response.body)['data'];
//     print(await response.stream.bytesToString());
//   } else {
//     print(response.reasonPhrase);
//   }
//   return null;
// }

Future<void> readJson(List<Standing> list_team) async {
  if (list_team != null) return;
  final String response = await rootBundle.loadString('assets/js.json');
  final res = await json.decode(response)['response'][0]['league']['standings'][0];
  list_team = List<Standing>.from(res.map<Standing>((dynamic i) => Standing.fromJson(i)));
}



// Future<List<TeamData_Standing>> fetchPost() async {
//   print("1111111111111");
//   var headers = {'x-rapidapi-key': '5a50f7fb113c8fe8ba1e6615e3ba32ab', 'x-rapidapi-host': 'v3.football.api-sports.io'};
//   var request = http.Request('GET', Uri.parse('https://v3.football.api-sports.io/standings?league=39&season=2022'));
//   request.headers.addAll(headers);
//   print("33333333333");
//
//   print("44444444");
//   //final response = await http.get(Uri.parse(Uri.parse(request)));
//
//   print("44444444 ${response.statusCode}");
//   if (response.statusCode == 200) {
//     final res = json.decode(response.body)['data'];
//     print(await response.stream.bytesToString());
//   } else {
//     print(response.reasonPhrase);
//   }
//   return null;
// }

