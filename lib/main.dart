import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopup/providers/auth.dart';



import 'providers/products_provider.dart';
import '../providers/orders.dart';
import 'providers/cart.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import '../screens/orders_screen.dart.';
import '../screens/product_overview.dart';
import '../screens/user_products_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/auth_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items,
              ),
        ),
        ,
        ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ShopUp',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            hintColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home:  auth.isAuth ? ProductOverview() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
             OrdersScreen.routeName: (ctx) => OrdersScreen(),
             UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
