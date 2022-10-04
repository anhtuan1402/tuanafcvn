import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:afcvn/Model/News_Data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';

List<Data_News> list_data;

Future<void> readJsonNews() async {
  print(list_data);
  if (list_data != null) return;

  var link = 'https://api.afcvn.host/v1/news/GetNews';
  Map data = {'PageIndex': 1, 'PageSize': 10, 'SearchValue': ''};
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

class News extends StatefulWidget {
  News({Key key}) : super(key: key);

  @override
  News_state createState() => News_state();
}

class News_state extends State<News> {
  ScrollController _scrollController = ScrollController();
  final PageController controller = PageController(initialPage: 200);
  int pageNo = 0;
  PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readJsonNews(),
        builder: (context, snapshot) {
          if (list_data == null && !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          height: 280,
                          child: AnimatedBuilder(
                            animation: pageController,
                            builder: (ctx, child) {
                              return child;
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  right: 8, left: 8, top: 24, bottom: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Column(children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                      bottomLeft: Radius.circular(16.0),
                                      bottomRight: Radius.circular(16.0)),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        list_data[0].thumbnail,
                                        height: 220,
                                        width: 350,
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          )),
                      Container(child: gridB(list_data))
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget gridB(List<Data_News> list_news) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 0.0,
          mainAxisExtent: 260,
        ),
        itemCount: list_news.length,
        itemBuilder: (_, index) {
          String day = list_news[index].createdDate.substring(8, 10);
          String month = list_news[index].createdDate.substring(5, 7);
          String year = list_news[index].createdDate.substring(0, 4);
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                16.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0)),
                  child: Image.network(
                    list_news[index].thumbnail,
                    height: 120,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list_news[index].title,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.subtitle1.merge(
                              const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "$day-$month-$year, ${list_news[index].views} lượt xem",
                        style: Theme.of(context).textTheme.subtitle2.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500,
                                  fontSize: 10),
                            ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
