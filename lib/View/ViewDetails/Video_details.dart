import 'package:afcvn/Database/Data_video.dart';
import 'package:afcvn/Model/Video_Data.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

String url;

class Video_details extends StatefulWidget {
  String url_play;

  Video_details({Key key, this.url_play}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    url = url_play;
    return Video_details_state();
  }
}

class Video_details_state extends State<Video_details> {
  String urls;
  PodPlayerController controller;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      readJsonVideo();
    });

    return;
  }

  @override
  void initState() {
    urls = url;
    urls = urls.substring(31, 40);
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.vimeo(urls),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              "Video chi tiết",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            )),
        body: NewWidget(context, url),
      ),
    );
  }

  Widget NewWidget(BuildContext context, String urlVideo) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 10.0, right: 5),
      child: FutureBuilder(
          future: readJsonVideo(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return list_View(snapshot.data, context, urlVideo);
            }
          }),
    );
  }

  Widget list_View(
      List<Video_Data> listData, BuildContext context, String urlPlay) {
    return Column(
      children: [
        Expanded(flex: 12, child: Slide()),
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Gợi ý dành cho bạn",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(10, 18, 32, 1)),
              ),
            )),
        Expanded(
          flex: 20,
          child: ListView.builder(
              itemCount: listData.length,
              itemBuilder: (context, index) {
                return Item_view(listData[index], context);
              }),
        ),
      ],
    );
  }

  Widget Slide() {
    return PodVideoPlayer(controller: controller);
  }

  Widget Item_view(Video_Data dataItem, BuildContext context) {
    String day0 = dataItem.createdDate.substring(8, 10);
    String month0 = dataItem.createdDate.substring(5, 7);
    String year0 = dataItem.createdDate.substring(0, 4);
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Video_details(
                      url_play: dataItem.videoLink,
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
              color: Colors.white,
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
