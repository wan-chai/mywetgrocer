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
    final String total = cartNotifier.cartList.map<double>((m) => double.parse(m.subTotal)).reduce((value,element) => value + element).toStringAsFixed(2);


    print("building CartList");
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart - cartList.dart",
        ),
        actions: <Widget>[
          // action button
          //cart button
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(cartNotifier.cartList[index].productName),
                  subtitle: Text("RM${cartNotifier.cartList[index].price}/kg X ${cartNotifier.cartList[index].quantity} = RM${cartNotifier.cartList[index].subTotal}"),
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
        ],
      ),
 
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text('TOTAL: ',
              style: TextStyle(
                //color: Colors.green, 
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
          ),
          FlatButton(
            child: Text('RM $total',
              style: TextStyle(
                color: Colors.orange, 
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
          ),
            onPressed: () {},
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () {},
            child: Icon(Icons.check_outlined),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white, 
          ),
        ],
      ),
      
    );
  }
}