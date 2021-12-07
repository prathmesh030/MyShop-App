import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });

  Map toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'quantity': quantity,
      };
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItemToCart(String title, String prodId, double price) {
    if (_items.containsKey(prodId)) {
      _items.update(
          prodId,
          (existCartItem) => CartItem(
                id: existCartItem.id,
                title: existCartItem.title,
                price: existCartItem.price,
                quantity: existCartItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          prodId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeItemFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void undoCartItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (exprod) => CartItem(
                id: exprod.id,
                title: exprod.title,
                price: exprod.price,
                quantity: exprod.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
