import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  String description;
  String category;
  String id;
  String title;
  double price;
  List<dynamic> images;
  List<dynamic> sizes;

  Products();

  Products.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"] + 0.0;
    images = snapshot.data["images"];
    sizes = snapshot.data["sizes"];
  }
  Map<String, dynamic> toResumeMap(){
    return {
      'title':title,
      //'description': description,
      'price': price,
    };
  }
}
