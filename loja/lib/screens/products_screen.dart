//flutter
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:loja/widgets/float_cart.dart';
import 'package:scoped_model/scoped_model.dart';

//models
import '../models/products.dart';
import '../models/user_model.dart';
import '../models/cart_model.dart';
import '../models/cart_products.dart';

//Screens
import '../screens/login_screen.dart';

//widgets
import '../widgets/float_cart.dart';

class ProductsScreen extends StatefulWidget {
  final Products products;
  ProductsScreen(this.products);
  @override
  _ProductsScreenState createState() => _ProductsScreenState(products);
}

class _ProductsScreenState extends State<ProductsScreen> {
  final Products products;
  _ProductsScreenState(this.products);

  String size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(products.title),
        centerTitle: true,
      ),
      floatingActionButton: FloatCart(),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: products.images.map((url) => NetworkImage(url)).toList(),
              dotSize: 4,
              dotSpacing: 15,
              dotBgColor: Colors.transparent,
              dotColor: Theme.of(context).primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  products.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$${products.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5,
                    ),
                    children: products.sizes.map((e) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = e;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: size == e
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                                width: 3,
                                color: Theme.of(context).primaryColor),
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            e,
                            style: TextStyle(
                              color: size == e
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: ScopedModelDescendant<UserModel>(
                      builder: (context, child, model) {
                    if (!model.isLoggedIn()) {
                      return RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          "Entre ou Cadastre-se!",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        color: Theme.of(context).primaryColor,
                      );
                    } else {
                      return ScopedModelDescendant<CartModel>(
                          builder: (context, child, model) {
                        return RaisedButton(
                          onPressed: size != null
                              ? () {
                                  CartProduct cartProduct = CartProduct();
                                  cartProduct.pid = products.id;
                                  cartProduct.size = size;
                                  cartProduct.quantity = 1;
                                  cartProduct.category = products.category;
                                  cartProduct.products = products;
                                  model.addCartItem(cartProduct);
                                }
                              : null,
                          child: Text(
                            "Adicionar ao Carrinho",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          color: Theme.of(context).primaryColor,
                        );
                      });
                    }
                  }),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Descrição",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  products.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
