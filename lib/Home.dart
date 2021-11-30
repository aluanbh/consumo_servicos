import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //criação do crontrolador para captura do TextField
  TextEditingController _controllerCep = TextEditingController();
  String _resultadoFinal = "Resultado";

  //Função criada para obter o cep do api
  _recuperarCep() async {
    String cep = "";
    cep = _controllerCep.text;
    String url = "https://viacep.com.br/ws/${cep}/json/";
    http.Response response;

    response = await http.get(url);
    //converter a resposta para objeto json e depois armazenou em um objeto map
    Map<String, dynamic> retorno = json.decode(response.body);
    String logradouro = retorno["logradouro"];
    String bairro = retorno["bairro"];
    String localidade = retorno["localidade"];
    String uf = retorno["uf"];
    String ddd = retorno["ddd"];


    if (response.statusCode.toString() == 401 || logradouro==null) {
      setState(() {
        _resultadoFinal =
        "Digite todos os 8 digitos do CEP válido, somente usando números";
      });
    }else{
      setState(() {
        _resultadoFinal = "Logradouro: ${logradouro}\nBairro: ${bairro}\nCidade: ${localidade}\nEstado: ${uf}\nDDD: ${ddd}";
      });
    }

    print(
        "Logradouro: ${logradouro}\n"
        "Bairro: ${bairro}\n"
        "Cidade: ${localidade}\n"
        "Estado: ${uf}\n"
        "DDD: ${ddd}");
    //print("resposta: " + response.statusCode.toString());
    //print("resposta: " + response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text("Consulta CEP"),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Digite seu CEP",),
              maxLength: 8,
              maxLengthEnforced: true,
              style: TextStyle(fontSize: 22),
              controller: _controllerCep,
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                    child: Text("Encontrar endereço"),
                    onPressed: _recuperarCep)),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(_resultadoFinal,style: TextStyle(fontSize: 20),),
            )
          ],
        ),
      ),
    );
  }
}
