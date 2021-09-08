// To parse this JSON data, do
//
//     final statesResult = statesResultFromJson(jsonString);

import 'dart:convert';

StatesResult statesResultFromJson(String str) =>
    StatesResult.fromJson(json.decode(str));

String statesResultToJson(StatesResult data) => json.encode(data.toJson());

class StatesResult {
  StatesResult({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory StatesResult.fromJson(Map<String, dynamic> json) => StatesResult(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.city,
    required this.cityIbgeCode,
    required this.confirmed,
    required this.confirmedPer100KInhabitants,
    required this.date,
    required this.deathRate,
    required this.deaths,
    required this.estimatedPopulation,
    required this.estimatedPopulation2019,
    required this.isLast,
    required this.placeType,
    required this.state,
  });

  dynamic city;
  String cityIbgeCode;
  int confirmed;
  double confirmedPer100KInhabitants;
  DateTime date;
  double deathRate;
  int deaths;
  int estimatedPopulation;
  int estimatedPopulation2019;
  bool isLast;
  String placeType;
  String state;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        city: json["city"],
        cityIbgeCode: json["city_ibge_code"],
        confirmed: json["confirmed"],
        confirmedPer100KInhabitants:
            json["confirmed_per_100k_inhabitants"].toDouble(),
        date: DateTime.parse(json["date"]),
        deathRate:
            json["death_rate"] == null ? null : json["death_rate"].toDouble(),
        deaths: json["deaths"],
        estimatedPopulation: json["estimated_population"],
        estimatedPopulation2019: json["estimated_population_2019"],
        isLast: json["is_last"],
        placeType: json["place_type"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "city_ibge_code": cityIbgeCode,
        "confirmed": confirmed,
        "confirmed_per_100k_inhabitants": confirmedPer100KInhabitants,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "death_rate": deathRate == null ? null : deathRate,
        "deaths": deaths,
        "estimated_population": estimatedPopulation,
        "estimated_population_2019": estimatedPopulation2019,
        "is_last": isLast,
        "place_type": placeType,
        "state": state,
      };
}
