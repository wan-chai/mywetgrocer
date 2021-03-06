import 'dart:collection';

import 'package:mywetgrocer_app/model/cart.dart';
import 'package:flutter/cupertino.dart';

class CartNotifier with ChangeNotifier {
  List<Cart> _cartList = [];
  Cart _currentCart;

  UnmodifiableListView<Cart> get cartList => UnmodifiableListView(_cartList);

  Cart get currentCart => _currentCart;

  set cartList(List<Cart> cartList) {
    _cartList = cartList;
    notifyListeners();
  }

  set currentCart(Cart cart) {
    _currentCart = cart;
    notifyListeners();
  }
}
