import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedproduct = Provider.of<Products>(context).findById(productId);

    return Scaffold(
        appBar: AppBar(
          title: Text(loadedproduct.title),
        ),
        body: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(loadedproduct.imgURL),
            ),
            Divider(
              height: 2,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "\$${loadedproduct.price}",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              alignment: Alignment.center,
              width: 300,
              height: 100,
              child: Text(
                loadedproduct.description,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
  }
}
