import 'package:flutter/material.dart';
import './edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshedProducts(BuildContext context) async {
    // print("refresh");
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetupProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    print("rebuilding");
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      body: FutureBuilder(
        future: _refreshedProducts(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshedProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemBuilder: (ctx, index) => Column(
                            children: [
                              Divider(),
                              UserProductItem(
                                id: productsData.items[index].id,
                                title: productsData.items[index].title,
                                imageUrl: productsData.items[index].imgURL,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: productsData.items.length,
                        ),
                      ),
                    )),
      ),
      drawer: AppDrawer(),
    );
  }
}
