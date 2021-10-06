import 'package:covidmonitor/model/stateInfo.dart';

class StateInfoSearchResult {
  StateInfoSearchResult({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<StateInfo> results;

  factory StateInfoSearchResult.fromJson(Map<String, dynamic> json) =>
      StateInfoSearchResult(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<StateInfo>.from(
            json["results"].map((x) => StateInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
