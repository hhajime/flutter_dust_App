import 'package:flutter_application_1/models/AirResult.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/main.dart';
import 'dart:convert';

void main() {
  test('http 통신 테스트', () async {
    var response = await http.get(Uri.parse(
        'https://api.airvisual.com/v2/nearest_city?key=f6687020-5eb6-4dc6-8f81-fcddf2987403'));

    expect(response.statusCode, 200);
    AirResult result = AirResult.fromJson(json.decode(response.body));
    expect(result.status, 'success');
  });
}
