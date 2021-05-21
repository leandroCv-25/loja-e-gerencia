//flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

//models
import 'cart_products.dart';
import 'user_model.dart';

class CartModel extends Model {
  UserModel userModel;
  List<CartProduct> products = [];
  bool isLoading = false;

  String couponCode;
  int discountPercentage = 0;

  CartModel(this.userModel) {
    if (userModel.isLoggedIn()) {
      _loadCartItens();
    }
  }

  void addCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection('users')
        .document(userModel.firebaseUser.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.documentID;
      products.add(cartProduct);
      notifyListeners();
    });
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection('users')
        .document(userModel.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cart) {
    cart.quantity--;
    Firestore.instance
        .collection('users')
        .document(userModel.firebaseUser.uid)
        .collection('cart')
        .document(cart.cid)
        .updateData(cart.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cart) {
    cart.quantity++;
    Firestore.instance
        .collection('users')
        .document(userModel.firebaseUser.uid)
        .collection('cart')
        .document(cart.cid)
        .updateData(cart.toMap());
    notifyListeners();
  }

  void setCoupon(String couponCode, int percentage) {
    this.couponCode = couponCode;
    this.discountPercentage = percentage;
    //notifyListeners();
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0;
    for (CartProduct c in products) {
      if (c.products != null) {
        price += c.quantity * c.products.price;
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  void _loadCartItens() async {
    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(userModel.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  Future<String> finishingOrder() async {
    if (products == null) return null;
    isLoading = true;
    notifyListeners();

    double price = getProductsPrice();
    double discount = getDiscount();
    double ship = getShipPrice();
    double total = price + ship - discount;

    DocumentReference refOrder = await Firestore.instance.collection('orders').add({
      'clientId': userModel.firebaseUser.uid,
      'products': products.map((cart) => cart.toMap()).toList(),
      'shipPrice': ship,
      'discountPrice': discount,
      'productsPrice': price,
      'totalPrice': total,
      'adressShip': userModel.userData['adress'],
      'status': 1,
    });

    await Firestore.instance
        .collection('users')
        .document(userModel.firebaseUser.uid)
        .collection('orders')
        .document(refOrder.documentID)
        .setData({'orderId': refOrder.documentID});

    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(userModel.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();

    couponCode = null;
    discountPercentage = 0;
    
    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }
}
