import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderTime;

  OrderItem({
    @required this.amount,
    @required this.id,
    @required this.products,
    @required this.orderTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final authToken;
  final userId;

  Orders(this.authToken, this.userId, this._orders);

  Future<void> addToOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse('url');
    // print(cprods);
    try {
      var dt = new DateTime.now();

      final res = await http.post(url,
          body: json.encode({
            'amount': total,
            'products': cartProducts
                .map((cp) => {
                      "id": cp.id,
                      "title": cp.title,
                      "price": cp.price,
                      "quantity": cp.quantity,
                    })
                .toList(),
            'orderTime': dt.toIso8601String(),
          }));

      _orders.insert(
        0,
        OrderItem(
          amount: total,
          id: json.decode(res.body)['name'],
          products: cartProducts,
          orderTime: dt,
        ),
      );
      notifyListeners();
    } catch (err) {
      // print('---$err');
      throw err;
    }
  }

  // fetch orders
  Future<void> fetchOrders() async {
    final url = Uri.parse('url');

    try {
      final res = await http.get(url);
      // print(json.decode(res.body));

      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<OrderItem> loadedOrders = [];

      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          amount: orderData['amount'],
          id: orderData['name'],
          orderTime: DateTime.parse(orderData['orderTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }
}
