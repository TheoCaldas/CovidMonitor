import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'states.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Monitor de COVID-19 no Brasil'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<StatesResult> _statesResult;

  Future<StatesResult> fetchData() async {
    final String token = "e5349b4e3b8483d3a425f109b50a726e6afc0058";
    final response = await http.get(
        Uri.parse(
            'https://api.brasil.io/dataset/covid19/caso/data?is_last=True&place_type=state'),
        headers: {
          //'Content-Type': 'application/json',
          //'Accept': 'application/json',
          'Authorization': 'Token $token',
        });
    if (response.statusCode == 200) {
      final statesResult = statesResultFromJson(response.body);
      debugStateResult(statesResult);
      return statesResult;
    } else {
      print("statusCode: " + response.statusCode.toString());
      throw Exception('Failed to load results');
    }
  }

  void debugStateResult(StatesResult statesResult) {
    for (int i = 0; i < statesResult.results.length; i++) {
      Result stateResult = statesResult.results[i];
      print(stateResult.state +
          " - " +
          stateResult.confirmed.toString() +
          " - " +
          stateResult.confirmedPer100KInhabitants.toString() +
          " - " +
          stateResult.deaths.toString() +
          " - " +
          stateResult.deathRate.toString());
    }
  }

  @override
  void initState() {
    _statesResult = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<StatesResult>(
          future: _statesResult,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: const EdgeInsets.all(30),
                  itemCount: snapshot.data!.results.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            snapshot.data!.results[index].state,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(padding: EdgeInsets.all(30)),
                          Text(
                            "Casos confirmados: " +
                                snapshot.data!.results[index].confirmed
                                    .toString(),
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ));
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}