import 'package:flutter/material.dart';
import '../model/constants.dart';
import 'package:covidmonitor/model/stateInfo.dart';

class StateDetail extends StatelessWidget {
  StateDetail({Key? key, required this.title, required this.data})
      : super(key: key);

  final String title;
  final StateInfo data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        title: Text(title),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Spacer(),
              Text(
                "Ultima atualizacao - " +
                    data.date.day.toString() +
                    "/" +
                    data.date.month.toString() +
                    "/" +
                    data.date.year.toString(),
              ),
              Spacer(),
            ],
          ),
          Padding(padding: EdgeInsets.all(10)),
          Card(
            color: Constants.primaryColor,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Taxa de mortos: " + data.deathRate.toString(),
                style: Constants.theme.bodyText1,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Card(
            color: Constants.primaryColor,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Casos confirmados: " + data.confirmed.toString(),
                style: Constants.theme.bodyText1,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Card(
            color: Constants.primaryColor,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Total de óbitos: " + data.deaths.toString(),
                style: Constants.theme.bodyText1,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Card(
            color: Constants.primaryColor,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Casos/100 mil habitantes: " +
                    data.confirmedPer100KInhabitants.toString(),
                style: Constants.theme.bodyText1,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Card(
            color: Constants.primaryColor,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "População: " + data.estimatedPopulation.toString(),
                style: Constants.theme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
