import 'package:mywetgrocer_app/notifier/cartNotifier.dart';
import 'package:mywetgrocer_app/notifier/productNotifier.dart';
import 'package:mywetgrocer_app/screens/customers/productListCustomer.dart';
import 'package:mywetgrocer_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifier/authNotifier.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartNotifier(),
        ),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Wet Grocer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlue,
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? ProductListCustomer() : Login();
        },
      ),
    );
  }
}
