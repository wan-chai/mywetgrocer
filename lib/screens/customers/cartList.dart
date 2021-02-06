import 'package:mywetgrocer_app/controller/database.dart';
import 'package:mywetgrocer_app/model/cart.dart';
import 'package:mywetgrocer_app/notifier/authNotifier.dart';
import 'package:mywetgrocer_app/notifier/cartNotifier.dart';
import 'package:flutter/material.dart';
import 'package:mywetgrocer_app/screens/customers/cartDetail.dart';
import 'package:provider/provider.dart';

class CartList extends StatefulWidget {
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  Cart get cart => null;


  @override
  void initState() {
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context, listen: false);
    getCarts(cartNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context);

    print("building CartList");
    print("uid: ${authNotifier.user.uid}");
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart - cartList.dart",
        ),
        actions: <Widget>[
          // action button
          //cart button
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => CartList()),
              );
            },
          ),
          //logout button
          FlatButton(
            onPressed: () => signout(authNotifier),
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(cartNotifier.cartList[index].productName),
              
              subtitle: Text("RM${cartNotifier.cartList[index].price}/kg"),
              onTap: () {
                cartNotifier.currentCart = cartNotifier.cartList[index];
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return CartDetail();
                }));
              },
            );
          },
          itemCount: cartNotifier.cartList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.black,
            );
          },
        ),
        
      ),
      floatingActionButton: FlatButton(
            onPressed: (){

            },
            child: Text('CheckOut',
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
          )
          
    );
  }
}
