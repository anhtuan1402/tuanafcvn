import 'package:afcvn/Database/Data_News.dart';
import 'package:afcvn/Model/News_Data.dart';
import 'package:afcvn/View/ViewDetails/News_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class News extends StatefulWidget {
  const News({Key key}) : super(key: key);

  @override
  News_state createState() => News_state();
}

class News_state extends State<News> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final PageController controller = PageController(initialPage: 200);
  int pageNo = 0;
  PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    //refreshList();
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      readJsonNews_data();
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      child: FutureBuilder(
          future: readJsonNews_data(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              String day0 = snapshot.data[0].createdDate.substring(8, 10);
              String month0 = snapshot.data[0].createdDate.substring(5, 7);
              String year0 = snapshot.data[0].createdDate.substring(0, 4);
              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: AppBar(
                    backgroundColor: Colors.white10,
                    elevation: 0,
                    title: const Text(
                      "Tin tức",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                body: SafeArea(
                  child: GestureDetector(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                              height: 300,
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
                                                  id_news: snapshot.data[0].iD,
                                                  file_html:
                                                      snapshot.data[0].content,
                                                )));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 16,
                                        left: 16,
                                        top: 24,
                                        bottom: 12),
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
                                              snapshot.data[0].thumbnail,
                                              height: 260,
                                              width: double.maxFinite,
                                              fit: BoxFit.cover,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.bottomLeft,
                                                      colors: <Color>[
                                                    Color.fromRGBO(
                                                        23, 31, 47, 0),
                                                    Color.fromRGBO(
                                                        19, 27, 43, 0.35),
                                                    Color.fromRGBO(
                                                        16, 24, 39, 0.51),
                                                    Color.fromRGBO(
                                                        10, 18, 32, 1),
                                                  ])),
                                              child: Column(children: [
                                                RichText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  strutStyle: const StrutStyle(
                                                      fontSize: 12.0),
                                                  text: TextSpan(
                                                      text: snapshot
                                                          .data[0].title,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          .merge(const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              fontSize: 18))),

                                                  // style: Theme.of(context).textTheme.subtitle1.merge(
                                                  //   const TextStyle(
                                                  //     overflow: TextOverflow.visible,
                                                  //     color: Colors.white,
                                                  //     fontWeight: FontWeight.w700,
                                                  //   ),
                                                ),
                                                Text(
                                                  "$day0-$month0-$year0  •  ${snapshot.data[0].views} lượt xem",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2
                                                      .merge(
                                                        const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.white70,
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
                          Container(child: gridB(snapshot.data))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget gridB(List<Data_News> list_news) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 0.0,
          mainAxisExtent: 200,
        ),
        itemCount: list_news.length - 1,
        itemBuilder: (context, index) {
          index = index + 1;
          String nameTitle = list_news[index].title;

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
                      height: 108,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
            ),
          );
        },
      ),
    );
  }
}
