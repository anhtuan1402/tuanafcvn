import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';

class News extends StatefulWidget {
  News({Key key}) : super(key: key);

  @override
  News_state createState() => News_state();
}

class News_state extends State<News> {
  final PageController controller = PageController(initialPage: 200);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [],
    ));
  }
}
