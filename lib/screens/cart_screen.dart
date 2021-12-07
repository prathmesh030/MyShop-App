import 'package:flutter/material.dart';
import '../providers/cart.dart' show Cart;
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isOrdered = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    print("rebuilds");
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            elevation: 5,
            margin: EdgeInsets.all(15),
            child: Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                      onPressed: (isOrdered || cart.totalAmount <= 0)
                          ? null
                          : () async {
                              setState(() {
                                isOrdered = true;
                              });
                              try {
                                await Provider.of<Orders>(context,
                                        listen: false)
                                    .addToOrder(cart.items.values.toList(),
                                        cart.totalAmount);
                                setState(() {
                                  isOrdered = false;
                                });
                                cart.clearCart();
                              } catch (_) {}
                            },
                      child: isOrdered
                          ? CircularProgressIndicator()
                          : Text(
                              "ORDER NOW",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            )),
                ],
              ),
              padding: EdgeInsets.all(10),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => CartItem(
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                title: cart.items.values.toList()[index].title,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
              ),
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}
