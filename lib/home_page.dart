import 'package:aula08/classes/enum_app.dart';
import 'package:aula08/widgets/widget.load.dart';
import 'package:aula08/widgets/widget.resultado.dart';
import 'package:aula08/widgets/widget.topo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'classes/cep.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _ctrCEP = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  estadoApp situacao = estadoApp.epInicio;
  Cep cep;
  String _msg = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Topo(),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: TextFormField(
                    controller: _ctrCEP,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Digite o CEP',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '*Informe o CEP';
                      } else if (value.length != 8) {
                        limparResultado();
                        return '*CEP inválido';
                      }
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        limparTela();
                      }
                    },
                  ),
                ),
              ),
              Container(
                child: modificaContainer(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 3.0,
        child: Icon(Icons.search),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            this.situacao = estadoApp.epProcessando;
            setState(() {
              modificaContainer();
            });
            consultaCEP();
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        color: Theme.of(context).primaryColor,
        child: Container(
          height: 50,
        ),
      ),
    );
  }

  void consultaCEP() async {
    Dio dio = Dio();
    Response response;
    try {
      response =
          await dio.get("https://viacep.com.br/ws/" + _ctrCEP.text + '/json/');
      if (response.statusCode == 200 && response.data['erro'] != true) {
        this.situacao = estadoApp.epParado;
        this.cep = Cep.fromJson(response.data);
      } else {
        this.situacao = estadoApp.epErro;
        this._msg = 'CEP não encontrado!';
      }
    } catch (e) {
      this.situacao = estadoApp.epErro;
      this._msg = 'Erro ${e.toString()}';
    }

    setState(() {});
  }

  void limparTela() {
    setState(() {
      this.situacao = estadoApp.epInicio;
      _formKey.currentState.reset();
      _ctrCEP.clear();
      modificaContainer();
    });
  }

  void limparResultado() {
    setState(() {
      this.situacao = estadoApp.epInicio;
      modificaContainer();
    });
  }

  Widget modificaContainer() {
    switch (this.situacao) {
      case estadoApp.epProcessando:
        return Loader();
        break;
      case estadoApp.epParado:
        return Resultado(cep: this.cep);
        break;
      case estadoApp.epInicio:
        return Container();
        break;
      case estadoApp.epErro:
        return Text(
          this._msg,
          style: TextStyle(color: Colors.red, fontSize: 30),
          textAlign: TextAlign.center,
        );
        break;
      default:
        return Container();
        break;
    }
  }
}
