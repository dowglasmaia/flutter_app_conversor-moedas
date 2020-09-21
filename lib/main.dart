import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:async/async.dart';

const apiFinanceUrl =
    "https://api.hgbrasil.com/finance?format=json-cors&key=7ed0c8ac";

void main() async {
  http.Response response = await http.get(apiFinanceUrl);

  json.decode(response.body);
  /* ACESSSANDO OS DADOS DO JSON */
  print(json.decode(response.body)
     ['results']
     ['currencies']
     ['EUR']
  );

  runApp(MaterialApp(
    home: Container(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
