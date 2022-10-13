import 'package:afcvn/Database/Data_Result.dart';
import 'package:afcvn/Model/Scheduler_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Result extends StatefulWidget {
  const Result({Key key}) : super(key: key);

  @override
  Result_state createState() => Result_state();
}

class Result_state extends State<Result> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  var prefs;
  var jsonString_scheduler_result;

  Future<dynamic> init_first() async {
    prefs = await SharedPreferences.getInstance();
    jsonString_scheduler_result = prefs.getString("json_schedule_result");
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      api_readJson_scheduler_result();
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    init_first();
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      child: FutureBuilder(
          future: jsonString_scheduler_result == null
              ? api_readJson_scheduler_result_first()
              : readJson_scheduler_result(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return PageBody(snapshot.data, context);
            }
            // return Container(child: list_ne(list_scheduler));
          }),
    );
  }

  Widget PageBody(List<Response_Scheduler> allmatches, BuildContext context) {
    return Container(
      //Color.fromRGBO(235, 241, 252, 0.5)
      color: Theme.of(context)
          .backgroundColor
          .withGreen(235)
          .withGreen(241)
          .withBlue(252)
          .withOpacity(0.5),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        itemCount: allmatches.length,
        itemBuilder: (context, index) {
          return matchTile(allmatches[index]);
        },
      ),
    );
  }

  Widget matchTile(Response_Scheduler match) {
    String homeGoal =
        match.goals.home == null ? "" : match.goals.home.toString();
    String awayGoal =
        match.goals.away == null ? "" : match.goals.away.toString();
    bool isHome = match.teams.home.id == 42;
    bool isAway = match.teams.away.id == 42;

    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Container(
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
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: [
                    Time_List(match.fixture.status.short),
                    Expanded(
                      flex: 20,
                      child: Column(children: [
                        Row(
                          children: [
                            Image.network(
                              match.teams.home.logo,
                              width: 25.0,
                            ),
                            Text(" ${match.teams.home.name}",
                                textAlign: TextAlign.center,
                                style: isHome
                                    ? const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      )
                                    : const TextStyle(
                                        color: Color.fromRGBO(10, 18, 32, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ))
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Image.network(
                              match.teams.away.logo,
                              width: 25.0,
                            ),
                            Text(" ${match.teams.away.name}",
                                textAlign: TextAlign.center,
                                style: isAway
                                    ? const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      )
                                    : const TextStyle(
                                        color: Color.fromRGBO(10, 18, 32, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ))
                          ],
                        ),
                      ]),
                    ),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              homeGoal,
                              textAlign: TextAlign.center,
                              style: isHome
                                  ? const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    )
                                  : const TextStyle(
                                      color: Color.fromRGBO(10, 18, 32, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              awayGoal,
                              textAlign: TextAlign.center,
                              style: isAway
                                  ? const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    )
                                  : const TextStyle(
                                      color: Color.fromRGBO(10, 18, 32, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
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
