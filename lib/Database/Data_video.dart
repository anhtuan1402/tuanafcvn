import 'dart:convert';
import 'dart:io';

import 'package:afcvn/Model/Video_Data.dart';
import 'package:http/http.dart' as http;

int count_api = 0;
List<Video_Data> listVideo;

Future<List<Video_Data>> readJsonVideo() async {
  if (listVideo != null) return listVideo;
  var link = 'https://api.afcvn.host/v1/video/GetVideos';
  Map data = {'PageIndex': 1, 'PageSize': 10, 'SearchValue': ''};
  var bodyString = json.encode(data);
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  final response =
      await http.post(Uri.parse(link), headers: headers, body: bodyString);
  if (response.statusCode == 200) {
    final res = json.decode(response.body)['Data'];
    listVideo = List<Video_Data>.from(
        res.map<Video_Data>((dynamic i) => Video_Data.fromJson(i)));
  }
  return listVideo;
}
