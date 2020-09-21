import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const apiFinanceUrl =
    "https://api.hgbrasil.com/finance?format=json-cors&key=7ed0c8ac";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
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
  double dolar;
  double euro;

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
                  /*capturando o valor de compra do Dolar, que recebemos da responta da API.*/
                  dolar = snapshort.data['results']['currencies']['USD']['buy'];
                  euro = snapshort.data['results']['currencies']['EUR']['buy'];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch, //cetralizar
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150.0,
                          color: Colors.amber,
                        ),

                        /*REAL*/
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Reais",
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder(),
                            prefixText: "R\$",
                          ),
                          style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        ),

                        /* DOLAR*/
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Dolares",
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder(),
                            prefixText: "US\$",
                          ),
                          style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        ),

                        /*EURO*/
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Euro",
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder(),
                            prefixText: "€",
                          ),
                          style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        ),
                        Divider(),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}
