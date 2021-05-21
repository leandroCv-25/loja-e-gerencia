//flutter
import 'package:flutter/material.dart';
import 'package:loja/widgets/ship_cart.dart';
import 'package:scoped_model/scoped_model.dart';

//models
import '../models/cart_model.dart';

//screens
import '../screens/login_screen.dart';
import '../screens/order_screen.dart';

//widgets
import '../widgets/cart_tile.dart';
import '../widgets/discont_cart.dart';
import '../widgets/price_cart.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(builder: (context, child, model){
              int p = model.products.length;
              return Text('${p??0} ${p==1?"Item":"Itens"}', style: TextStyle(fontSize: 17),);
            }),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(builder: (context, child, model){
        if(model.isLoading&&model.userModel.isLoggedIn()){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else if (!model.userModel.isLoggedIn()){
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.remove_shopping_cart, size: 80,color: Theme.of(context).primaryColor,),
                SizedBox(height: 16,),
                Text("Faça o login para acessar o carrinho", style: Theme.of(context).textTheme.bodyText1,),
                SizedBox(height: 16,),
                RaisedButton(
                  child: Text("Entrar", style: Theme.of(context).textTheme.bodyText2,),
                  color: Theme.of(context).primaryColor,
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
                })
              ],
            ),
          );
        } else if(model.products==null||model.products.length==0){
          return Center(
            child: Text("Nenhum produto no Carrinho", style: Theme.of(context).textTheme.headline5,),
          );
        } else{
          return ListView(
            children: <Widget>[
              Column(
                children: model.products.map((cart) => CartTile(cart)).toList(),
              ),
              DiscontCart(),
              ShipCart(),
              PriceCart(()async{
                String orderId = await model.finishingOrder();
                if(orderId!=null){
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrderScreen(orderId)));
                }
              }),
            ],
          );
        }
      }),
    );
  }
}