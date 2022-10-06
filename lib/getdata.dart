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
