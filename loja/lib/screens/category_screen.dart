//flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//models
import '../models/products.dart';
//widgets
import '../widgets/products_tile.dart';
import '../widgets/float_cart.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatCart(),
        appBar: AppBar(
          title: Text(snapshot.data["title"],
              style: Theme.of(context).textTheme.bodyText1),
          centerTitle: true,
          bottom: TabBar(indicatorColor: Colors.white, tabs: <Widget>[
            Tab(
              icon: Icon(Icons.grid_on),
            ),
            Tab(
              icon: Icon(Icons.list),
            )
          ]),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection('products')
              .document(snapshot.documentID)
              .collection('products')
              .getDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );
            } else {
              return TabBarView(
                children: [
                  GridView.builder(
                    itemCount: snapshot.data.documents.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 2,
                    ),
                    itemBuilder: (context, i) {
                      Products data = Products.fromDocument(snapshot.data.documents[i]);
                      data.category = this.snapshot.documentID;
                      return ProductTile('grid', data);
                    },
                  ),
                  ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, i) {
                      Products data = Products.fromDocument(snapshot.data.documents[i]);
                      data.category = this.snapshot.documentID;
                      return ProductTile('list',
                          data);
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
