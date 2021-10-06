class StateInfo {
  StateInfo({
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

  factory StateInfo.fromJson(Map<String, dynamic> json) => StateInfo(
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
