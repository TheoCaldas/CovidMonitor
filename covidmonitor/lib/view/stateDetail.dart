import 'package:flutter/material.dart';
import '../model/constants.dart';
import 'package:covidmonitor/model/stateInfo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StateDetail extends StatelessWidget {
  StateDetail({Key? key, required this.title, required this.data})
      : super(key: key);

  final String title;
  final StateInfo data;

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
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
                t!.sd1 +
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
                t!.sd2 + data.deathRate.toString(),
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
                t!.sd3 + data.confirmed.toString(),
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
                t!.sd4 + data.deaths.toString(),
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
                t!.sd5 + data.confirmedPer100KInhabitants.toString(),
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
                t!.sd6 + data.estimatedPopulation.toString(),
                style: Constants.theme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
