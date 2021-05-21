//flutter
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//screens
import './screens/home_screen.dart';

//models
import './models/user_model.dart';
import './models/cart_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        return ScopedModel<CartModel>(
          model: CartModel(model),
          child: MaterialApp(
            title: 'Flutter\'s Clothing',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              primaryColor: Color.fromARGB(255, 4, 125, 141),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                bodyText2: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          ),
        );
      }),
    );
  }
}
