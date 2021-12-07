import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final listOfOrders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapshot.error != null) {
            return Center(
              child: Text("Something went wrong!"),
            );
          } else {
            return Consumer<Orders>(
                builder: (context, ordersData, child) => ListView.builder(
                      itemBuilder: (ctx, index) => OrderItem(
                        order: ordersData.orders[index],
                      ),
                      itemCount: ordersData.orders.length,
                    ));
          }
        },
      ),
    );
  }
}




// # 1 way loading orders
// stateful widget used
//  bool isLoading = false;
//   @override
//   void initState() {
//     Future.delayed(Duration.zero).then((_) async {
//       setState(() {
//         isLoading = true;
//       });
//       await Provider.of<Orders>(context, listen: false).fetchOrders();
//       setState(() {
//         isLoading = false;
//       });
//     });
//     super.initState();
//   }




// #2 way loading  orders
// stateful widget used
  // bool isLoading = false;
  // @override
  // void initState() {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   Provider.of<Orders>(context, listen: false).fetchOrders().then((value) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });

  //   super.initState();
  // }

  // #3 way loading orders
  // Future ordersFuture;
  // Future _obtainOrdersFuture()
  // {
  // return  Provider.of<Orders>(context, listen: false).fetchOrders();
  // }

  // void initState()
//{
  // ordersFuture = _obtainOrdersFuture();
  // use orderFuture in build method in FutureBuilder
//}
