//flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//models
import '../models/cart_model.dart';

class DiscontCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          'Cupom de desconto',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          ScopedModelDescendant<CartModel>(builder: (context, child, model) {
            return Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite seu cupom",
                ),
                initialValue: model.couponCode ?? "",
                onFieldSubmitted: (text) {
                  Firestore.instance
                      .collection('coupons')
                      .document(text)
                      .get()
                      .then((doc) {
                    if (doc.data != null &&
                        DateTime.now()
                            .isBefore(DateTime.parse(doc.data['valid']))) {
                      model.setCoupon(text, doc.data["percent"]);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Desconto  de ${doc.data["percent"]}%!",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ));
                    } else {
                      model.setCoupon(null, 0);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Cupom invalido!",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        backgroundColor: Colors.red,
                      ));
                    }
                  });
                },
              ),
            );
          })
        ],
      ),
    );
  }
}
