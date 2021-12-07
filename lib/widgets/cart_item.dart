import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final double price;
  final String productId;
  final String id;
  final int quantity;
  final String title;

  CartItem({
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are you sure?"),
                  content: Text("Do you want to remove this product?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text("NO")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text("Yes")),
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItemFromCart(productId);
      },
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: IconButton(
          icon: Icon(
            Icons.delete,
            size: 40,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          onPressed: () {},
        ),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline6.color,
                  ),
                ),
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          title: Text(title),
          subtitle: Text('Total - ${(price * quantity).toStringAsFixed(2)}'),
          trailing: Text('Qt - $quantity X'),
        ),
      ),
    );
  }
}
