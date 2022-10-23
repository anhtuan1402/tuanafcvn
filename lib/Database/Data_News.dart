import 'dart:convert';
import 'dart:io';

import 'package:afcvn/Model/News_Data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

int count_api = 0;
List<Data_News> list_data_news;

Future<List<Data_News>> readJsonNews_data() async {
  if (list_data_news != null) return list_data_news;
  var link = 'https://api.afcvn.host/v1/news/GetNews';
  Map data = {'PageIndex': 1, 'PageSize': 50, 'SearchValue': ''};
  var bodyString = json.encode(data);
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

  final response =
      await http.post(Uri.parse(link), headers: headers, body: bodyString);
  if (response.statusCode == 200) {
    final res = json.decode(response.body)['Data'];
    list_data_news = List<Data_News>.from(
        res.map<Data_News>((dynamic i) => Data_News.fromJson(i)));
  }
  return list_data_news;
}
