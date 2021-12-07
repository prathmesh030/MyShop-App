import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import './screens/splash_screen.dart';
import './screens/user_products_screen.dart';
import './providers/orders.dart';
import './providers/auth.dart';

import './screens/product_details_screen.dart';
import './providers/products.dart';
import './screens/products_list_screen.dart';
import './screens/orders_screen.dart';

import './screens/cart_screen.dart';
import './screens/auth_screen.dart';
import './providers/cart.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, null, []),
          update: (ctx, auth, previousProds) => Products(auth.token,
              auth.userId, previousProds == null ? [] : previousProds.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(null, null, []),
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Shop App",
            theme: ThemeData(
              accentColor: Colors.amberAccent,
              primarySwatch: Colors.amber,
              fontFamily: 'Lato',
            ),
            // initialRoute: "/products",
            home: auth.isAuth
                ? ProductsListScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              ProductsListScreen.routeName: (ctx) => ProductsListScreen(),
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            }),
      ),
    );
  }
}
