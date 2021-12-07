import 'package:flutter/material.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String id;
  final imageUrl;

  UserProductItem({
    this.id,
    this.imageUrl,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (err) {
                  print(id);
                  print(err);
                  scaffold
                      .showSnackBar(SnackBar(content: Text("Deleting Failed")));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
