import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const apiFinanceUrl =
    "https://api.hgbrasil.com/finance?format=json-cors&key=7ed0c8ac";

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> getDataApiFinance() async {
  http.Response response = await http.get(apiFinanceUrl);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      //BARRA
      appBar: AppBar(
        title: Text(" \$ Conversor de Moedas \$"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),

      //CORPO
      body: FutureBuilder<Map>(
          future: getDataApiFinance(), //dados esperados
          builder: (context, snapshort) {
            switch (snapshort.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                  ),
                );
              default:
                if (snapshort.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    color: Colors.green,
                  );
                }
            }
          }),
    );
  }
}
