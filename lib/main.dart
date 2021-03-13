import 'package:ShopApp/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // use de .value on the class if you don't need the context
    // this use is more used in single items or lists
    // because the away flutter renders the data off screen for example.
    //return ChangeNotifierProvider.value(
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // create is use on the version >4 of the provider package
          create: (ctx) => Auth(),
        ),
        // ChangeNotifierProxy is a way to manipulate de changes in this case on the Auth
        // Have to make sure the class you want to manipulate is above the class you changing
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (ctx, auth, previous) => ProductsProvider(
            auth.token,
            auth.userId,
            previous == null ? [] : previous.items,
          ),
          create: null,
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previous) => Orders(
            auth.token,
            previous == null ? [] : previous.orders,
          ),
          create: null,
          //create: (ctx) => ProductsProvider(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
