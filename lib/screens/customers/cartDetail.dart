import 'package:mywetgrocer_app/controller/database.dart';
import 'package:mywetgrocer_app/notifier/cartNotifier.dart';
import 'package:flutter/material.dart';
import 'package:mywetgrocer_app/screens/customers/cartForm.dart';
import 'package:provider/provider.dart';

class CartDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('View Cart Detail 2'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 24),
                Text(
                  cartNotifier.currentCart.productName,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text("RM${
                  cartNotifier.currentCart.price}/kg",
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text("Quantity : ${
                  cartNotifier.currentCart.quantity}",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Text("Total : RM${
                  cartNotifier.currentCart.subTotal}",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () {
              
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return CartForm(
                    isSelectCart: true,
                  ); 
                }),
              );
              
            },
            child: Icon(Icons.edit),
            foregroundColor: Colors.white,
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () => deleteCart(
              productName: cartNotifier.currentCart.productName,
            uid: cartNotifier.currentCart.uid),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
