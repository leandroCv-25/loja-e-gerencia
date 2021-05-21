//flutter
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//models
import '../models/cart_model.dart';

class PriceCart extends StatelessWidget {
  final Function function;
  PriceCart(this.function);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            double price = model.getProductsPrice();
            double discount = model.getDiscount();
            double ship = model.getShipPrice();

            return Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Resumo do Pedido",
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Subtotal",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        "R\$${price.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ]),
                Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                          "Desconto", style: Theme.of(context).textTheme.bodyText1,),
                      Text(
                        "R\$${discount.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ]),
                Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Entrega",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        "R\$${ship.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ]),
                Divider(),
                SizedBox(
                  height: 12,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Total",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        "R\$${(price+ship-discount).toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ]),
                SizedBox(
                  height: 12,
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Finalizar Pedido',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: function,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
