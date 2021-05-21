//flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//models
import '../models/cart_products.dart';
import '../models/products.dart';
import '../models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct cart;
  CartTile(this.cart);
  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      return ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          model.updatePrices();
          return Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                width: 120,
                child: Image.network(
                  cart.products.images[0],
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(cart.products.title,
                        style: Theme.of(context).textTheme.headline6),
                    Text(
                      "Tamanho ${cart.size}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      "R\$${cart.products.price.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: ()=> model.incProduct(cart)),
                        Text(
                          cart.quantity.toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        IconButton(
                            icon: Icon(Icons.remove,
                                color: Theme.of(context).primaryColor),
                            onPressed: cart.quantity > 1 ? () {
                              model.decProduct(cart);
                            } : null),
                        FlatButton(
                            child: Text(
                              "Remover",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            onPressed: () {
                              model.removeCartItem(cart);
                            }),
                      ],
                    )
                  ],
                ),
              ))
            ],
          );
        },
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: cart.products == null
          ? FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection('products')
                  .document(cart.category)
                  .collection('products')
                  .document(cart.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  cart.products = Products.fromDocument(snapshot.data);
                  return _buildContent();
                } else {
                  return Container(
                    height: 70,
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
                }
              },
            )
          : _buildContent(),
    );
  }
}
