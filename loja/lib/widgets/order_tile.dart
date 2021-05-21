//flutter
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;

  OrderTile(this.order);

  _buildProductText() {
    String text = "Descrição: \n";
    for (LinkedHashMap p in order.data['products']) {
      text +=
          '${p['quantity']} x ${p['products']['title']} (${p['size']}) por R\$${(p['products']['price']).toStringAsFixed(2)}';
    }
    return text +=
        "\nTotal: R\$ ${order.data['totalPrice'].toStringAsFixed(2)}";
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle, style: TextStyle(color: Colors.grey),)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int status = order.data["status"];
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Pedido: ${order.documentID}",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 4),
            Text(
              _buildProductText(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              "Status do Pedido:",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildCircle("1", "Preparação", status, 1),
                Container(
                  height: 1.0,
                  width: 40.0,
                  color: Colors.grey[500],
                ),
                _buildCircle("2", "Transporte", status, 2),
                Container(
                  height: 1.0,
                  width: 40.0,
                  color: Colors.grey[500],
                ),
                _buildCircle("3", "Entrega", status, 3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
