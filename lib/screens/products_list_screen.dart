import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favourites,
  ShowAll,
}

class ProductsListScreen extends StatefulWidget {
  static const routeName = '/products';

  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  var _showFavs = false;
  bool inIt = true;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (inIt) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetupProducts().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }

    inIt = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop App"),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selected) {
                // print(selected);

                setState(() {
                  if (selected == FilterOptions.Favourites) {
                    _showFavs = true;
                  } else {
                    _showFavs = false;
                  }
                });
              },
              itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: Text("Favourites"),
                      value: FilterOptions.Favourites,
                    ),
                    PopupMenuItem(
                      child: Text("Show all"),
                      value: FilterOptions.ShowAll,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavs),
    );
  }
}
