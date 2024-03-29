import 'package:afcvn/Database/Data_video.dart';
import 'package:afcvn/Model/Video_Data.dart';
import 'package:afcvn/View/ViewDetails/Video_details.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class Video extends StatefulWidget {
  const Video({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return Video_State();
  }
}

class Video_State extends State<Video> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      readJsonVideo();
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              "Video",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            )),
        body: Container(
          color: const Color.fromRGBO(235, 241, 252, 0.5),
          padding: const EdgeInsets.only(left: 10.0, right: 5),
          child: FutureBuilder(
              future: readJsonVideo(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      "No API",
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  );
                } else {
                  return list_View(snapshot.data, context);
                }
              }),
        ),
      ),
    );
  }

  Widget list_View(List<Video_Data> listData, BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 1, child: Slide2(listData, context)),
        Expanded(
          flex: 2,
          child: ListView.builder(
              itemCount: listData.length,
              itemBuilder: (context, index) {
                return Item_view(listData[index], context);
              }),
        ),
      ],
    );
  }

  Widget Slide2(List<Video_Data> listData, BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: double.infinity,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,
        aspectRatio: 2.0,
      ),
      items: listData
          .map((e) => GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Video_details(
                                data_video: e,
                              )));
                },
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Image.network(
                                e.thumbnail,
                              ),
                              const ImageIcon(
                                AssetImage('assets/Videos.png'),
                                color: Colors.red,
                              )
                            ],
                          ),
                        ),
                        Text(
                          e.title,
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(10, 18, 32, 1)),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget Slide(List<Video_Data> listData, BuildContext context) {
    return GestureDetector(
      child: GFCarousel(
        items: listData.map(
          (url) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Video_details(
                              data_video: url,
                            )));
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                    )),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Stack(alignment: Alignment.center, children: [
                          Image.network(url.thumbnail),
                          const ImageIcon(
                            AssetImage('assets/Videos.png'),
                            color: Colors.red,
                          )
                        ]),
                      ),
                      Text(
                        url.title,
                        style: const TextStyle(
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

  Widget Item_view(Video_Data dataItem, BuildContext context) {
    String day0 = dataItem.createdDate.substring(8, 10);
    String month0 = dataItem.createdDate.substring(5, 7);
    String year0 = dataItem.createdDate.substring(0, 4);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Video_details(
                      data_video: dataItem,
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
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(dataItem.thumbnail),
                            //Icon(Icons.play_circle_filled_sharp,color: Colors.red,size: 40,),
                            const ImageIcon(
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
                          dataItem.title,
                          style: const TextStyle(
                              color: Color.fromRGBO(10, 18, 32, 1),
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "$day0/$month0/$year0  •  ${dataItem.views} lượt xem",
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
}
