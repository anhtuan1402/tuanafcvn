import 'dart:convert';

class Response_Scheduler {
  Response_Scheduler({
    this.fixture,
    this.league,
    this.teams,
    this.goals,
    this.score,
  });
  Fixture fixture;
  League league;
  Teams teams;
  Goals goals;
  Score score;

  Response_Scheduler.fromJson(Map<String, dynamic> json) {
    fixture = Fixture.fromJson(json['fixture']);
    league = League.fromJson(json['league']);
    teams = Teams.fromJson(json['teams']);
    goals = Goals.fromJson(json['goals']);
    score = Score.fromJson(json['score']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fixture'] = fixture.toJson();
    _data['league'] = league.toJson();
    _data['teams'] = teams.toJson();
    _data['goals'] = goals.toJson();
    _data['score'] = score.toJson();
    return _data;
  }
}

class Fixture {
  Fixture({
    this.id,
    this.referee,
    this.timezone,
    this.date,
    this.timestamp,
    this.periods,
    this.venue,
    this.status,
  });

  int id;
  String referee;
  String timezone;
  String date;
  int timestamp;
  Periods periods;
  Venue venue;
  Status status;

  Fixture.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referee = null;
    timezone = json['timezone'];
    date = json['date'];
    timestamp = json['timestamp'];
    periods = Periods.fromJson(json['periods']);
    venue = Venue.fromJson(json['venue']);
    status = Status.fromJson(json['status']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['referee'] = referee;
    _data['timezone'] = timezone;
    _data['date'] = date;
    _data['timestamp'] = timestamp;
    _data['periods'] = periods.toJson();
    _data['venue'] = venue.toJson();
    _data['status'] = status.toJson();
    return _data;
  }
}

class Periods {
  Periods({
    this.first,
    this.second,
  });

  int first;
  int second;

  Periods.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    second = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['first'] = first;
    _data['second'] = second;
    return _data;
  }
}

class Venue {
  Venue({
    this.id,
    this.name,
    this.city,
  });
  int id;
  String name;
  String city;

  Venue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['city'] = city;
    return _data;
  }
}

class Status {
  Status({
    this.long,
    this.short,
    this.elapsed,
  });
  String long;
  String short;
  int elapsed;

  Status.fromJson(Map<String, dynamic> json) {
    long = json['long'];
    short = json['short'];
    elapsed = json['elapsed'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['long'] = long;
    _data['short'] = short;
    _data['elapsed'] = elapsed;
    return _data;
  }
}

class League {
  League({
    this.id,
    this.name,
    this.country,
    this.logo,
    this.flag,
    this.season,
    this.round,
  });
  int id;
  String name;
  String country;
  String logo;
  String flag;
  int season;
  String round;

  League.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
    logo = json['logo'];
    flag = json['flag'];
    season = json['season'];
    round = json['round'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['country'] = country;
    _data['logo'] = logo;
    _data['flag'] = flag;
    _data['season'] = season;
    _data['round'] = round;
    return _data;
  }
}

class Teams {
  Teams({
    this.home,
    this.away,
  });
  Home home;
  Away away;

  Teams.fromJson(Map<String, dynamic> json) {
    home = Home.fromJson(json['home']);
    away = Away.fromJson(json['away']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['home'] = home.toJson();
    _data['away'] = away.toJson();
    return _data;
  }
}

class Home {
  Home({
    this.id,
    this.name,
    this.logo,
    this.winner,
  });
  int id;
  String name;
  String logo;
  bool winner;

  Home.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    winner = json['winner'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['logo'] = logo;
    _data['winner'] = winner;
    return _data;
  }
}

class Away {
  Away({
    this.id,
    this.name,
    this.logo,
    this.winner,
  });
  int id;
  String name;
  String logo;
  bool winner;

  Away.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    winner = json['winner'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['logo'] = logo;
    _data['winner'] = winner;
    return _data;
  }
}

class Goals {
  Goals({
    this.home,
    this.away,
  });
  int home;
  int away;

  Goals.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    away = json['away'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['home'] = home;
    _data['away'] = away;
    return _data;
  }
}

class Score {
  Score({
    this.halftime,
    this.fulltime,
    this.extratime,
    this.penalty,
  });
  Halftime halftime;
  Fulltime fulltime;
  Extratime extratime;
  Penalty penalty;

  Score.fromJson(Map<String, dynamic> json) {
    halftime = Halftime.fromJson(json['halftime']);
    fulltime = Fulltime.fromJson(json['fulltime']);
    extratime = Extratime.fromJson(json['extratime']);
    penalty = Penalty.fromJson(json['penalty']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['halftime'] = halftime.toJson();
    _data['fulltime'] = fulltime.toJson();
    _data['extratime'] = extratime.toJson();
    _data['penalty'] = penalty.toJson();
    return _data;
  }
}

class Halftime {
  Halftime({
    this.home,
    this.away,
  });
  int home;
  int away;

  Halftime.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    away = json['away'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['home'] = home;
    _data['away'] = away;
    return _data;
  }
}

class Fulltime {
  Fulltime({
    this.home,
    this.away,
  });

  dynamic home;
  dynamic away;

  Fulltime.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    away = json['away'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['home'] = home;
    _data['away'] = away;
    return _data;
  }
}

class Extratime {
  Extratime({
    this.home,
    this.away,
  });

  dynamic home;
  dynamic away;

  Extratime.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    away = json['away'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['home'] = home;
    _data['away'] = away;
    return _data;
  }
}

class Penalty {
  Penalty({
    this.home,
    this.away,
  });

  dynamic home;
  dynamic away;

  Penalty.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    away = json['away'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['home'] = home;
    _data['away'] = away;
    return _data;
  }
}
