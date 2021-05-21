//flutter
import 'package:flutter/material.dart';
//Tabs
import '../tabs/home_tab.dart';
import '../tabs/products_tab.dart';
import '../tabs/orders_tab.dart';
import '../tabs/places_tab.dart';

//Widgets
import '../widgets/app_drawer.dart';
import '../widgets/float_cart.dart';

class HomeScreen extends StatelessWidget {
  final _pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageViewController,
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          floatingActionButton: FloatCart(),
          drawer: AppDrawer(_pageViewController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Produtos",
            ),
            centerTitle: true,
          ),
          floatingActionButton: FloatCart(),
          drawer: AppDrawer(_pageViewController),
          body: ProductsTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Lojas",
            ),
            centerTitle: true,
          ),
          floatingActionButton: FloatCart(),
          drawer: AppDrawer(_pageViewController),
          body: PlacesTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Meus Pedidos",
            ),
            centerTitle: true,
          ),
          drawer: AppDrawer(_pageViewController),
          body: OrdersTab(),
        ),
      ],
    );
  }
}
