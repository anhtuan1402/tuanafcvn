import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

Future<void> readJsonNews(int idNews) async {
  var link = 'https://api.afcvn.host/v1/news/$idNews';
  await http.get(Uri.parse(link));
}

class News_details extends StatelessWidget {
  final int id_news;
  final String file_html;

  const News_details({Key key, this.id_news, this.file_html}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    readJsonNews(id_news);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: const Text(
              "Chi tiết bài viết",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            )),
        // ignore: unnecessary_new
        body: new Center(
          child: SingleChildScrollView(
            child: Html(
              data: file_html,
            ),
          ),
        ));
  }
}
