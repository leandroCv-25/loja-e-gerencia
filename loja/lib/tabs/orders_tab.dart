//flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//models
import '../models/user_model.dart';

//screens
import '../screens/login_screen.dart';

//widgets
import '../widgets/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.isLoggedIn()) {
          return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('orders')
                .where('clientId', isEqualTo: model.firebaseUser.uid)
                .getDocuments().asStream(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting ||
                  snap.connectionState == ConnectionState.none) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: snap.data.documents.length,
                  itemBuilder: (context, i){
                    return OrderTile(snap.data.documents[i]);
                  });
              }
            },
          );
        } else if (!model.isLoggedIn()) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.view_list,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Faça o login para acessar os pedidos",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton(
                    child: Text(
                      "Entrar",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    })
              ],
            ),
          );
        }
      },
    );
  }
}
