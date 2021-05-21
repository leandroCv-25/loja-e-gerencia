//dart
import 'dart:async';

//flutter
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//Models
import '../models/user_model.dart';

class SingUpScreen extends StatefulWidget {
  @override
  _SingUpScreenState createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final _formkey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passController = TextEditingController();

  final _adressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void onSucess() {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "Usuário criado com sucesso!",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      Future.delayed(Duration(seconds: 2))
          .then((value) => Navigator.of(context).pop());
    }

    void onFail() {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "Falha ao criar o usuário!",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isloading)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Form(
            key: _formkey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Nome Completo",
                  ),
                  validator: (text) {
                    if (text.isEmpty) return "Nome inválido";
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "E-mail",
                  ),
                  validator: (text) {
                    if (text.isEmpty || !text.contains('@'))
                      return "E-mail inválido";
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                    hintText: "Senha",
                  ),
                  obscureText: true,
                  validator: (text) {
                    if (text.isEmpty || text.length < 6)
                      return "Senha inválida";
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _adressController,
                  decoration: InputDecoration(
                    hintText: "Endereço",
                  ),
                  validator: (text) {
                    if (text.isEmpty) return "Endereço inválido";
                    return null;
                  },
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        final Map<String, dynamic> data = {
                          'email': _emailController.text,
                          'name': _nameController.text,
                          'adress': _adressController.text,
                        };
                        model.signUp(
                            userData: data,
                            pass: _passController.text,
                            onSucess: onSucess,
                            onFail: onFail);
                      }
                    },
                    child: Text(
                      "Criar Conta",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
