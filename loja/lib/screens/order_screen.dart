//flutter
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final String orderId;

  OrderScreen(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido Realizado"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check, size: 80, color: Theme.of(context).primaryColor),
            Text(
              "Pedido Realizado com sucesso!",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text('Codigo do pedido $orderId', style: Theme.of(context).textTheme.bodyText1,),
          ],
        ),
      ),
    );
  }
}
