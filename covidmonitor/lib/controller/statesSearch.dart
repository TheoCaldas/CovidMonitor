import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:covidmonitor/model/stateInfo.dart';
import 'package:covidmonitor/model/stateInfoSearchResult.dart';

StateInfoSearchResult stateInfoSearchResultFromJson(String str) =>
    StateInfoSearchResult.fromJson(json.decode(str));

String stateInfoSearchResultToJson(StateInfoSearchResult data) =>
    json.encode(data.toJson());

Future<StateInfoSearchResult> fetchData() async {
  await dotenv.load(fileName: "token.env");
  final String token = dotenv.get('TOKEN');
  final response = await http.get(
      Uri.parse(
          'https://api.brasil.io/dataset/covid19/caso/data?is_last=True&place_type=state'),
      headers: {
        'Authorization': 'Token $token',
      });
  if (response.statusCode == 200) {
    final statesInfo = stateInfoSearchResultFromJson(response.body);
    return statesInfo;
  } else {
    print("statusCode: " + response.statusCode.toString());
    throw Exception('Failed to load results');
  }
}

void debugStateInfoSearchResult(StateInfoSearchResult stateInfoSearchResult) {
  for (int i = 0; i < stateInfoSearchResult.results.length; i++) {
    StateInfo stateInfo = stateInfoSearchResult.results[i];
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
