import 'dart:convert';
import 'dart:io';

import 'package:afcvn/Model/News_Data.dart';
import 'package:afcvn/News_details.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

List<Data_News> list_data;

Future<void> readJsonNews() async {
  if (list_data != null) return;

  var link = 'https://api.afcvn.host/v1/news/GetNews';
  Map data = {'PageIndex': 1, 'PageSize': 10, 'SearchValue': ''};
  var bodyString = json.encode(data);
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

  final response = await http.post(Uri.parse(link), headers: headers, body: bodyString);

  if (response.statusCode == 200) {
    final res = json.decode(response.body)['Data'];
    list_data = List<Data_News>.from(res.map<Data_News>((dynamic i) => Data_News.fromJson(i)));
  }
}

Future<void> readJsonNews_local() async {
  final String response = await rootBundle.loadString('assets/js_news.json');
  final res = await json.decode(response)['Data'];
  list_data = List<Data_News>.from(res.map<Data_News>((dynamic i) => Data_News.fromJson(i)));
}

class News extends StatefulWidget {
  News({Key key}) : super(key: key);

  @override
  News_state createState() => News_state();
}

class News_state extends State<News> {
  final PageController controller = PageController(initialPage: 200);
  int pageNo = 0;
  PageController pageController = PageController(initialPage: 0, viewportFraction: 0.85);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readJsonNews(),
        builder: (context, snapshot) {
          if (list_data == null && !snapshot.hasData) {
            return const Center(child: const CircularProgressIndicator());
          } else {
            String day0 = list_data[0].createdDate.substring(8, 10);
            String month0 = list_data[0].createdDate.substring(5, 7);
            String year0 = list_data[0].createdDate.substring(0, 4);
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: AppBar(
                    backgroundColor: Colors.white10,
                    elevation: 0,
                    title: const Text(
                      "Tin tức",
                      style: TextStyle(fontSize:24,color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                ),
              ),
              body: SafeArea(
                child: GestureDetector(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: 256,
                            child: AnimatedBuilder(
                              animation: pageController,
                              builder: (ctx, child) {
                                return child;
                              },
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => News_details(
                                                id_news: list_data[0].iD,
                                                file_html: list_data[0].content,
                                              )));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8, left: 8, top: 24, bottom: 12),
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
                                        alignment: Alignment.bottomLeft,
                                        //fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            list_data[0].thumbnail,
                                            height: 220,
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(5.0),
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                                gradient: LinearGradient(begin: Alignment.bottomLeft, colors: <Color>[
                                              Color.fromRGBO(23, 31, 47, 0),
                                              Color.fromRGBO(19, 27, 43, 0.35),
                                              Color.fromRGBO(16, 24, 39, 0.51),
                                              Color.fromRGBO(10, 18, 32, 1),
                                            ])),
                                            child: Column(children: [
                                              RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                strutStyle: const StrutStyle(fontSize: 12.0),
                                                text: TextSpan(
                                                    text: list_data[0].title,
                                                    style: Theme.of(context).textTheme.subtitle1.merge(const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w700,
                                                        overflow: TextOverflow.visible,
                                                        fontSize: 18))),

                                                // style: Theme.of(context).textTheme.subtitle1.merge(
                                                //   const TextStyle(
                                                //     overflow: TextOverflow.visible,
                                                //     color: Colors.white,
                                                //     fontWeight: FontWeight.w700,
                                                //   ),
                                              ),
                                              Text(
                                                "$day0-$month0-$year0  •  ${list_data[0].views} lượt xem",
                                                style: Theme.of(context).textTheme.subtitle2.merge(
                                                      const TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white70,
                                                          fontSize: 10),
                                                    ),
                                              ),
                                            ]),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            )),
                        Container(child: gridB(list_data))
                      ],
                    ),
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
          mainAxisExtent: 200,
        ),
        itemCount: list_news.length - 1,
        itemBuilder: (context, index) {
          index = index + 1;
          String name_title = list_news[index].title;
          if (name_title.length > 45) {
            name_title = name_title.substring(0, 42) + "...";
          }

          String day = list_news[index].createdDate.substring(8, 10);
          String month = list_news[index].createdDate.substring(5, 7);
          String year = list_news[index].createdDate.substring(0, 4);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => News_details(
                            id_news: list_news[index].iD,
                            file_html: list_news[index].content,
                          )));
            },
            child: Container(
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
                      width: 250,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name_title,
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
                          "$day-$month-$year  •  ${list_news[index].views} lượt xem",
                          style: Theme.of(context).textTheme.subtitle2.merge(
                                TextStyle(fontWeight: FontWeight.w700, color: Colors.grey.shade500, fontSize: 10),
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
            ),
          );
        },
      ),
    );
  }
}
