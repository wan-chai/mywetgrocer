import 'package:mywetgrocer_app/controller/database.dart';
import 'package:mywetgrocer_app/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:mywetgrocer_app/notifier/authNotifier.dart';
import 'package:mywetgrocer_app/notifier/cartNotifier.dart';
import 'package:provider/provider.dart';

class CartForm extends StatefulWidget {
  final bool isSelectCart;

  CartForm({@required this.isSelectCart});

  @override
  _CartFormState createState() => _CartFormState();
}

class _CartFormState extends State<CartForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Cart _currentCart;
  String quantity;
  String subTotal;
  String prouctName;
  String price;

 
  @override
  void initState() {
    super.initState();
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context, listen: false);
    _currentCart = cartNotifier.currentCart;
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Insert To Cart')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          //autovalidate: true,
          child: Column(children: <Widget>[
            SizedBox(height: 16),
            Text(_currentCart.productName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 0),
            Text("RM${_currentCart.price}/kg",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 15), 
          /*
            TextFormField(
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              //initialValue: quantity,
              style: TextStyle(fontSize: 20),
              validator: (int val) {
                if (val.isEmpty) {
                  return 'Quantity is required';
                }
                return null;
              },
              onChanged: (val) => setState(() => quantity = val),
            ),  
          */

            TextFormField(
              decoration: InputDecoration(labelText: 'Quantity'),
              //initialValue: _currentProduct.quantity,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Quantity is required';
                }

                return null;
              },
              onChanged: (value) => setState(() => quantity = value),
            ),
          /*
            TextFormField(
              decoration: InputDecoration(labelText: 'Total'),
              initialValue: _currentCart.subTotal,
              style: TextStyle(fontSize: 20),
              validator: (val) {
                if (val.isEmpty) {
                  return 'Quantity is required';
                }
                return null;
              },
              onChanged: (val) => setState(() => subTotal = val),
            ), 
          */
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
                    if(_formKey.currentState.validate()) {
                      await  saveUpdateToCart(uid: authNotifier.user.uid, 
                        productId: _currentCart.id,
                        productName: _currentCart.productName,
                        price: _currentCart.price,
                        quantity: quantity,
                        //subTotal: subTotal
                      );
                      print('cart saved');
                      print("uid: ${authNotifier.user.uid}");
                      print("proId: ${_currentCart.id}");
                    }
                    Navigator.pop(context);
                  },
        child: Icon(Icons.check_rounded),
        foregroundColor: Colors.white,
      ),
    );
  }
}
