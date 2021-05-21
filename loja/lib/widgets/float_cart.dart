//flutter
import 'package:flutter/material.dart';

//screens
import '../screens/cart_screen.dart';

class FloatCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CartScreen()));
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
