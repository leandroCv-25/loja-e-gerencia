//flutter
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//Screen
import './sign_up_screen.dart';

//Models
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();

  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void onSucess() {
      Navigator.of(context).pop();
    }

    void onFail() {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "Falha ao entrar!",
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
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SingUpScreen()));
            },
            child: Text(
              "Criar Conta",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          )
        ],
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
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(
                              "Insira seu e-mail para recuperar a senha!",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else{
                        model.recoverPass(_emailController.text);
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(
                              "Confira seu e-mail",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor:Theme.of(context).primaryColor,
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Esqueci minha senha",
                      textAlign: TextAlign.right,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        model.signIn(
                            email: _emailController.text,
                            pass: _passController.text,
                            onSucess: onSucess,
                            onFail: onFail);
                      }
                    },
                    child: Text(
                      "Entrar",
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
