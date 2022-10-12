// To parse this JSON data, do
//
//     final teamData = teamDataFromJson(jsonString);
// @dart=2.9
import 'dart:convert';

TeamData teamDataFromJson(String str) => TeamData.fromJson(json.decode(str));

String teamDataToJson(TeamData data) => json.encode(data.toJson());

class TeamData {
  TeamData({
    this.teamDataGet,
    this.parameters,
    this.errors,
    this.results,
    this.paging,
    this.response,
  });

  String teamDataGet;
  Parameters parameters;
  List<dynamic> errors;
  int results;
  Paging paging;
  List<Response> response;

  factory TeamData.fromJson(Map<String, dynamic> json) => TeamData(
        teamDataGet: json["get"],
        parameters: Parameters.fromJson(json["parameters"]),
        errors: List<dynamic>.from(json["errors"].map((x) => x)),
        results: json["results"],
        paging: Paging.fromJson(json["paging"]),
        response: List<Response>.from(
            json["response"].map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "get": teamDataGet,
        "parameters": parameters.toJson(),
        "errors": List<dynamic>.from(errors.map((x) => x)),
        "results": results,
        "paging": paging.toJson(),
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class Paging {
  Paging({
    this.current,
    this.total,
  });

  int current;
  int total;

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
        current: json["current"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current": current,
        "total": total,
      };
}

class Parameters {
  Parameters({
    this.league,
    this.season,
  });

  String league;
  String season;

  factory Parameters.fromJson(Map<String, dynamic> json) => Parameters(
        league: json["league"],
        season: json["season"],
      );

  Map<String, dynamic> toJson() => {
        "league": league,
        "season": season,
      };
}

class Response {
  Response({
    this.league,
  });

  League league;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        league: League.fromJson(json["league"]),
      );

  Map<String, dynamic> toJson() => {
        "league": league.toJson(),
      };
}

class League {
  League({
    this.id,
    this.name,
    this.country,
    this.logo,
    this.flag,
    this.season,
    this.standings,
  });

  int id;
  String name;
  String country;
  String logo;
  String flag;
  int season;
  List<List<Standing_model>> standings;

  factory League.fromJson(Map<String, dynamic> json) => League(
        id: json["id"],
        name: json["name"],
        country: json["country"],
        logo: json["logo"],
        flag: json["flag"],
        season: json["season"],
        standings: List<List<Standing_model>>.from(json["standings"].map((x) =>
            List<Standing_model>.from(
                x.map((x) => Standing_model.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country": country,
        "logo": logo,
        "flag": flag,
        "season": season,
        "standings": List<dynamic>.from(
            standings.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

class Standing_model {
  Standing_model({
    this.rank,
    this.team,
    this.points,
    this.goalsDiff,
    this.group,
    this.form,
    this.status,
    this.description,
    this.all,
    this.home,
    this.away,
    this.update,
  });

  int rank;
  Team team;
  int points;
  int goalsDiff;
  String group;
  String form;
  String status;
  String description;
  All all;
  All home;
  All away;
  DateTime update;

  factory Standing_model.fromJson(Map<String, dynamic> json) => Standing_model(
        rank: json["rank"],
        team: Team.fromJson(json["team"]),
        points: json["points"],
        goalsDiff: json["goalsDiff"],
        group: json["group"],
        form: json["form"],
        status: json["status"],
        description: json["description"],
        all: All.fromJson(json["all"]),
        home: All.fromJson(json["home"]),
        away: All.fromJson(json["away"]),
        update: DateTime.parse(json["update"]),
      );

  Map<String, dynamic> toJson() => {
        "rank": rank,
        "team": team.toJson(),
        "points": points,
        "goalsDiff": goalsDiff,
        "group": group,
        "form": form,
        "status": status,
        "description": description,
        "all": all.toJson(),
        "home": home.toJson(),
        "away": away.toJson(),
        "update": update.toIso8601String(),
      };
}

class All {
  All({
    this.played,
    this.win,
    this.draw,
    this.lose,
    this.goals,
  });

  int played;
  int win;
  int draw;
  int lose;
  Goals goals;

  factory All.fromJson(Map<String, dynamic> json) => All(
        played: json["played"],
        win: json["win"],
        draw: json["draw"],
        lose: json["lose"],
        goals: Goals.fromJson(json["goals"]),
      );

  Map<String, dynamic> toJson() => {
        "played": played,
        "win": win,
        "draw": draw,
        "lose": lose,
        "goals": goals.toJson(),
      };
}

class Goals {
  Goals({
    this.goalsFor,
    this.against,
  });

  int goalsFor;
  int against;

  factory Goals.fromJson(Map<String, dynamic> json) => Goals(
        goalsFor: json["for"],
        against: json["against"],
      );

  Map<String, dynamic> toJson() => {
        "for": goalsFor,
        "against": against,
      };
}

class Team {
  Team({
    this.id,
    this.name,
    this.logo,
  });

  int id;
  String name;
  String logo;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
      };
}
