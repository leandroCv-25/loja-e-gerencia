//flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isloading = false;

  @override
  void addListener(listener) {
    super.addListener(listener);

    _autoLogin();
  }

  void signUp({
    @required Map<String, dynamic> userData,
    @required String pass,
    @required Function onSucess,
    @required Function onFail,
  }) {
    isloading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: userData['email'], password: pass)
        .then((user) async {
      firebaseUser = user;
      await _saveUserData(userData);
      onSucess();
      isloading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isloading = false;
      notifyListeners();
    });
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required Function onSucess,
      @required Function onFail}) {
    isloading = true;
    notifyListeners();
    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      firebaseUser = user;
      await _loadUserData();
      onSucess();
      notifyListeners();
      isloading = false;
    }).catchError((e) {
      isloading = false;
      notifyListeners();
      onFail();  
    });
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<void> _loadUserData() async {
    final document = await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .get();
    userData = document.data;
  }

  Future<void> _autoLogin()async{
    if(firebaseUser==null){
      firebaseUser = await _auth.currentUser();
    }
    if(firebaseUser!=null){
      if(userData['name']==null){
        _loadUserData();
      }
    }
    notifyListeners();
  }
}
