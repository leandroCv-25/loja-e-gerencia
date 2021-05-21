//flutter
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

//widgets
import './body_back.dart';
import './draw_tile.dart';

//Screens
import '../screens/login_screen.dart';

//models
import '../models/user_model.dart';

class AppDrawer extends StatelessWidget {
  final PageController pageController;

  AppDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Stack(
          children: <Widget>[
            BodyBack(Theme.of(context).primaryColorDark, Colors.white),
            ListView(
              padding: const EdgeInsets.only(top: 16, left: 32),
              children: <Widget>[
                Container(
                  height: 170,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 8,
                        left: 0,
                        child: const Text(
                          "Flutter's\nClothing",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 34, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          child: ScopedModelDescendant<UserModel>(
                              builder: (context, child, model) {
                            return Column(
                              children: <Widget>[
                                Text(
                                  !model.isLoggedIn()
                                      ? "Olá,"
                                      : "Olá, ${model.userData['name']}",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                GestureDetector(
                                  child: Text(
                                    !model.isLoggedIn()
                                        ? "Entre ou cadastre-se"
                                        : "Sair",
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  onTap: () {
                                    !model.isLoggedIn()
                                        ? Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()))
                                        : model.signOut();
                                  },
                                ),
                              ],
                            );
                          })),
                    ],
                  ),
                ),
                DrawTile(
                  iconData: Icons.home,
                  text: "Inicio",
                  pageController: pageController,
                  page: 0,
                ),
                DrawTile(
                  iconData: Icons.list,
                  text: "Produtos",
                  pageController: pageController,
                  page: 1,
                ),
                DrawTile(
                  iconData: Icons.location_on,
                  text: "Lojas",
                  pageController: pageController,
                  page: 2,
                ),
                DrawTile(
                  iconData: Icons.playlist_add_check,
                  text: "Meus Pedidos",
                  pageController: pageController,
                  page: 3,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
