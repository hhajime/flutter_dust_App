import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/AirResult.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Welcome to Flutter', home: Main());
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  AirResult? _result;

  Future<AirResult> fetchData() async {
    var response = await http.get(Uri.parse(
        'https://api.airvisual.com/v2/nearest_city?key=f6687020-5eb6-4dc6-8f81-fcddf2987403'));

    AirResult result = AirResult.fromJson(json.decode(response.body));
    return result;
  }

  @override
  void initState() {
    super.initState();

    fetchData().then((airResult) {
      setState(() {
        _result = airResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _result == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '현재 위치 미세먼지',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Card(
                        child: Column(
                          children: [
                            Container(
                              color: getColor(_result!),
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '얼굴사진',
                                  ),
                                  Text(
                                    '${_result?.data.current.pollution.aqius ?? 0}',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  Text(
                                    getString(_result!),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Image.network(
                                        'https://airvisual.com/images/${_result?.data.current.weather.ic ?? 0}}.png',
                                        width: 32,
                                        height: 32,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                          '${_result?.data.current.weather.tp ?? 0}'),
                                    ],
                                  ),
                                  Text(
                                      '습도 ${_result?.data.current.weather.hu ?? 0}%'),
                                  Text(
                                      '풍속 ${_result?.data.current.weather.ws ?? 0}m/s'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ClipRect(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0))),
                              child: Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              onPressed: () {}))
                    ],
                  ),
                ),
              ));
  }

  Color getColor(AirResult result) {
    if (result.data.current.pollution.aqius < 50) {
      return Colors.greenAccent;
    } else if (result.data.current.pollution.aqius < 100) {
      return Colors.yellow;
    } else if (result.data.current.pollution.aqius < 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getString(AirResult result) {
    if (result.data.current.pollution.aqius < 50) {
      return '좋음';
    } else if (result.data.current.pollution.aqius < 100) {
      return '보통';
    } else if (result.data.current.pollution.aqius < 150) {
      return '나쁨';
    } else {
      return '최악';
    }
  }
}
