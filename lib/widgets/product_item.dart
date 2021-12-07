import 'package:flutter/material.dart';
import '../screens/product_details_screen.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

import '../providers/cart.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    // print("rebuilds");
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imgURL,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Color.fromRGBO(21, 22, 33, 0.8),
          leading: Consumer<Product>(
            builder: (ctx, producut, child) => IconButton(
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                product.toggleIsFav(authData.token, authData.userId);
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<Cart>(
            builder: (_, cart, child) => IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addItemToCart(product.title, product.id, product.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Added to the cart!"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.undoCartItem(product.id);
                      }),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
