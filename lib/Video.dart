import 'dart:convert';
import 'dart:io';

import 'package:afcvn/Model/Video_Data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

List<Video_Data> list_video;

Future<void> readJsonVideo() async {
  print("bbbbbbbbbbbb");
  var link = 'https://api.afcvn.host/v1/video/GetVideos';
  Map data = {'PageIndex': 1, 'PageSize': 1, 'SearchValue': ''};
  var bodyString = json.encode(data);
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

  final response =
      await http.post(Uri.parse(link), headers: headers, body: bodyString);
  if (response.statusCode == 200) {
    final res = json.decode(response.body)['Data'];
  }
}

Future<List<Video_Data>> readJsonVideo_Local() async {
  if (list_video != null) return list_video;
  final String response = await rootBundle.loadString('assets/js_video.json');
  final res = await json.decode(response)['Data'];
  list_video = List<Video_Data>.from(
      res.map<Video_Data>((dynamic i) => Video_Data.fromJson(i)));
  return list_video;
}

class Video extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Video",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          )),
      body: NewWidget(),
    );
  }

  void setState(Null Function() param0) {}
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readJsonVideo_Local(),
        builder: (context, snapshot) {
          if (list_video == null || !snapshot.hasData) {
            return const Center(child: const CircularProgressIndicator());
          } else {
            return list_View(list_video, context);
          }
        });
  }
}

Widget list_View(List<Video_Data> list_data, BuildContext context) {
  return ListView.builder(
      itemCount: list_data.length,
      itemBuilder: (context, index) {
        return Item_view(list_data[index], context);
      });
}

Widget Item_view(Video_Data data_item, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => null));
    },
    child: Row(
      children: [
        Expanded(
            flex: 5,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Image.network(data_item.thumbnail))),
        Expanded(flex: 5, child: Text(data_item.title)),
      ],
    ),
  );
}
