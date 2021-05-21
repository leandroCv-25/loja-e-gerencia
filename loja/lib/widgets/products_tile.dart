//flutter
import 'package:flutter/material.dart';

//models
import '../models/products.dart';

//Screens
import '../screens/products_screen.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final Products products;

  ProductTile(this.type, this.products);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>ProductsScreen(products))
        );
      },
      child: Card(
        child: type == 'grid'
            ? AspectRatio(
                aspectRatio: 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 0.80,
                      child: Image.network(
                        products.images[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Text(
                              products.title,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Text(
                              "R\$ ${products.price.toStringAsFixed(2)}",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Image.network(
                      products.images[0],
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Text(
                            products.title,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "R\$ ${products.price.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
