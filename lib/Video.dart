import 'dart:convert';
import 'dart:io';

import 'package:afcvn/Model/Video_Data.dart';
import 'package:afcvn/Video_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

List<Video_Data> list_video;

Future<List<Video_Data>> readJsonVideo() async {
  var link = 'https://api.afcvn.host/v1/video/GetVideos';
  Map data = {'PageIndex': 1, 'PageSize': 10, 'SearchValue': ''};
  var bodyString = json.encode(data);
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

  final response =
      await http.post(Uri.parse(link), headers: headers, body: bodyString);
  if (response.statusCode == 200) {
    final res = json.decode(response.body)['Data'];
    list_video = List<Video_Data>.from(
        res.map<Video_Data>((dynamic i) => Video_Data.fromJson(i)));
    return list_video;
  } else {
    print("readJsonVideo ${response.body}");
  }
  return list_video;
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
          elevation: 0,
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
    return Container(
      color: Color.fromRGBO(235, 241, 252, 0.5),
      padding: const EdgeInsets.only(left: 10.0, right: 5),
      child: FutureBuilder(
          future: readJsonVideo(),
          builder: (context, snapshot) {
            if (list_video == null || !snapshot.hasData) {
              return const Center(child: const CircularProgressIndicator());
            } else {
              return list_View(list_video, context);
            }
          }),
    );
  }
}

Widget list_View(List<Video_Data> list_data, BuildContext context) {
  return Column(
    children: [
      Expanded(flex: 6, child: Slide(list_data, context)),
      Expanded(
        flex: 10,
        child: ListView.builder(
            itemCount: list_data.length,
            itemBuilder: (context, index) {
              return Item_view(list_data[index], context);
            }),
      ),
    ],
  );
}

Widget slide2(List<Video_Data> list_data) {
  final _controller = PageController();
  return Scaffold(
    backgroundColor: Color.fromRGBO(235, 241, 252, 0.5),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // page view
        SizedBox(
          height: 200,
          child: PageView(
            controller: _controller,
            children: [
              Stack(alignment: Alignment.center, children: [
                Image.network(list_data[0].thumbnail),
                ImageIcon(
                  AssetImage('assets/Videos.png'),
                  color: Colors.red,
                  size: 50,
                )
              ]),
              Image.network(list_data[1].thumbnail),
              Image.network(list_data[2].thumbnail),
              Image.network(list_data[3].thumbnail),
            ],
          ),
        ),

        // dot indicators
        SmoothPageIndicator(
          controller: _controller,
          count: 4,
          effect: JumpingDotEffect(
            activeDotColor: Colors.grey,
            dotColor: Colors.deepPurple.shade100,
            dotHeight: 5,
            dotWidth: 5,
            spacing: 5,
            //verticalOffset: 50,
            jumpScale: 3,
          ),
        ),
      ],
    ),
  );
}

Widget Slide(List<Video_Data> list_data, BuildContext context) {
  return GestureDetector(
    child: GFCarousel(
      items: list_data.map(
        (url) {
          return GestureDetector(
            onTap: () {
              print("ON TAP ${url.videoLink}");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Video_details(
                            url_play: url.videoLink,
                          )));
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  )),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Stack(alignment: Alignment.center, children: [
                        Image.network(url.thumbnail),
                        ImageIcon(
                          AssetImage('assets/Videos.png'),
                          color: Colors.red,
                        )
                      ]),
                    ),
                    Text(
                      url.title,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(10, 18, 32, 1)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ).toList(),
    ),
  );
}

Widget Item_view(Video_Data data_item, BuildContext context) {
  String day0 = data_item.createdDate.substring(8, 10);
  String month0 = data_item.createdDate.substring(5, 7);
  String year0 = data_item.createdDate.substring(0, 4);
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Video_details(
                    url_play: data_item.videoLink,
                  )));
    },
    child: Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Container(
          padding: const EdgeInsets.all(5.0),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(235, 241, 252, 0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
              bottomLeft: Radius.circular(12.0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 5,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(data_item.thumbnail),
                          //Icon(Icons.play_circle_filled_sharp,color: Colors.red,size: 40,),
                          ImageIcon(
                            AssetImage('assets/Videos.png'),
                            color: Colors.red,
                            size: 50,
                          )
                        ],
                      ))),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Text(
                        data_item.title,
                        style: TextStyle(
                            color: Color.fromRGBO(10, 18, 32, 1),
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "$day0/$month0/$year0  •  ${data_item.views} lượt xem",
                        style: Theme.of(context).textTheme.subtitle2.merge(
                              const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10),
                            ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    ),
  );
}
