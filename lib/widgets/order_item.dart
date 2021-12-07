import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem({
    this.order,
  });

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.order.amount.toStringAsFixed(2)}"),
            subtitle: Text(
                DateFormat('d MMM yyyy hh:mm').format(widget.order.orderTime)),
            trailing: IconButton(
                icon: _expanded
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              height: min(widget.order.products.length * 20.0 + 50, 120),
              child: ListView(children: [
                Divider(),
                ...widget.order.products.map((prod) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        prod.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${prod.quantity}X ${prod.price}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  );
                }).toList(),
              ]),
            ),
        ],
      ),
    );
  }
}
