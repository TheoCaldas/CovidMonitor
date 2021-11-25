import 'package:covidmonitor/view/stateDetail.dart';
import 'package:flutter/material.dart';
import 'package:covidmonitor/model/constants.dart';
import 'package:covidmonitor/model/stateInfoSearchResult.dart';
import 'package:covidmonitor/controller/statesSearch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticsPage extends StatefulWidget {
  StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late Future<StateInfoSearchResult> _statesInfo;

  @override
  void initState() {
    _statesInfo = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Container(
      child: FutureBuilder<StateInfoSearchResult>(
        future: _statesInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.all(30),
                itemCount: snapshot.data!.results.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Constants.primaryColor,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StateDetail(
                                        title:
                                            snapshot.data!.results[index].state,
                                        data: snapshot.data!.results[index],
                                      )));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              snapshot.data!.results[index].state,
                              style: Constants.theme.headline1,
                            ),
                            Padding(padding: EdgeInsets.all(30)),
                            Text(
                              t!.statsPage +
                                  snapshot.data!.results[index].confirmed
                                      .toString(),
                              style: Constants.theme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
