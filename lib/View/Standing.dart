import 'package:afcvn/Database/Data_Standing.dart';
import 'package:afcvn/Model/TeamData.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Standing extends StatefulWidget {
  const Standing({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return Standing_State();
  }
}

class Standing_State extends State<Standing> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var prefs;
  var jsonString_standing;

  Future<dynamic> init_first() async {
    prefs = await SharedPreferences.getInstance();
    jsonString_standing = prefs.getString("json_standing");
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      api_readListTeam();
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    init_first();
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      child: Container(
        color: const Color.fromRGBO(235, 241, 252, 0.5),
        child: FutureBuilder(
            future: jsonString_standing == null
                ? api_readListTeam_first()
                : readListTeam(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return PageBody(snapshot.data, context);
              }
              // return Container(child: list_ne(list_scheduler));
            }),
      ),
    );
  }

  Widget PageBody(List<Standing_model> allmatches, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      itemCount: allmatches.length,
      itemBuilder: (context, index) {
        return matchTile(allmatches[index], context);
      },
    );
  }

  Widget matchTile(Standing_model data_team, BuildContext context) {
    return data_team.rank == 1
        ? Column(
            children: [
              Top_Row(context),
              const SizedBox(
                height: 4.0,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: data_team.team.id == 42
                      ? const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                          ),
                        )
                      : const BoxDecoration(
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
                          flex: 1,
                          child: Text(
                            data_team.rank.toString(),
                            textAlign: TextAlign.center,
                          )),
                      Expanded(
                        flex: 2,
                        child: Image.network(
                          data_team.team.logo,
                          width: 25.0,
                          height: 25.0,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          data_team.team.name,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data_team.all.played.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data_team.goalsDiff.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data_team.points.toString(),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )),
            ],
          )
        : Column(
            children: [
              const SizedBox(
                height: 4.0,
              ),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  decoration: data_team.team.id == 42
                      ? const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                          ),
                        )
                      : const BoxDecoration(
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
                          flex: 1,
                          child: Text(
                            data_team.rank.toString(),
                            textAlign: TextAlign.center,
                          )),
                      Expanded(
                        flex: 2,
                        child: Image.network(
                          data_team.team.logo,
                          width: 25.0,
                          height: 25.0,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          data_team.team.name,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data_team.all.played.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data_team.goalsDiff.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data_team.points.toString(),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )),
            ],
          );
  }
}

Widget Time_List(String status) {
  return Expanded(
    flex: 3,
    child: Text(
      status,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color.fromRGBO(10, 18, 32, 1),
        fontSize: 12.0,
      ),
    ),
  );
}

Widget Top_Row(BuildContext context) {
  return Container(
    color: Theme.of(context)
        .backgroundColor
        .withGreen(235)
        .withGreen(241)
        .withBlue(252)
        .withOpacity(0.5),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: const [
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            flex: 1,
            child: Text(
              '#',
              style: TextStyle(
                color: Color.fromRGBO(20, 56, 114, 1),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(""),
          ),
          Expanded(
            flex: 6,
            child: Text(
              'Đội',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(20, 56, 114, 1),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Trận",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(20, 56, 114, 1),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "HS",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(20, 56, 114, 1),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "Điểm",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(20, 56, 114, 1),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
