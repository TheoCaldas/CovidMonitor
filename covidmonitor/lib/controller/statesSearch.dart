import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:covidmonitor/model/stateInfo.dart';
import 'package:covidmonitor/model/stateInfoSearchResult.dart';

StateInfoSearchResult stateInfoSearchResultFromJson(String str) =>
    StateInfoSearchResult.fromJson(json.decode(str));

String stateInfoSearchResultToJson(StateInfoSearchResult data) =>
    json.encode(data.toJson());

Future<StateInfoSearchResult> fetchData() async {
  final String token = "e5349b4e3b8483d3a425f109b50a726e6afc0058";
  final response = await http.get(
      Uri.parse(
          'https://api.brasil.io/dataset/covid19/caso/data?is_last=True&place_type=state'),
      headers: {
        'Authorization': 'Token $token',
      });
  if (response.statusCode == 200) {
    final statesInfo = stateInfoSearchResultFromJson(response.body);
    // debugStateResult(statesResult);
    return statesInfo;
  } else {
    print("statusCode: " + response.statusCode.toString());
    throw Exception('Failed to load results');
  }
}

void debugStateResult(StateInfoSearchResult statesInfo) {
  for (int i = 0; i < statesInfo.results.length; i++) {
    StateInfo stateInfo = statesInfo.results[i];
    print(stateInfo.state +
        " - " +
        stateInfo.confirmed.toString() +
        " - " +
        stateInfo.confirmedPer100KInhabitants.toString() +
        " - " +
        stateInfo.deaths.toString() +
        " - " +
        stateInfo.deathRate.toString());
  }
}
