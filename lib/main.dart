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
  /*Criando controller para pegar os dados dos inputs*/
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _clearAll() {
    realController.text = "";
    euroController.text = "";
    dolarController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);

    print(real / dolar);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro)
        .toStringAsFixed(2); //converte paraq real e depois para euro.
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

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
                        Divider(),
                        buildTextFiel(
                            "Reais", "R\$", realController, _realChanged),
                        Divider(),
                        buildTextFiel(
                            "Dolares", "US\$", dolarController, _dolarChanged),
                        Divider(),
                        buildTextFiel(
                            "Euros", "€", euroController, _euroChanged),
                        Divider(),
                        Text(
                          "Desenvolvido por Dowglas Maia",
                          style: TextStyle(color: Colors.amber, fontSize: 14.0),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

/*CRIANDO O INPUT TEXTFIELD*/
Widget buildTextFiel(
    String label, String prefix, TextEditingController controller, Function f) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f, // pega as mudanças digitados no campo
    keyboardType: TextInputType.numberWithOptions(decimal: true), //Números decimais no iOS tbm
   // keyboardType: TextInputType.number, //define que somente numeros
  );
}
