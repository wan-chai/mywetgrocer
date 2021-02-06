import 'dart:io';
import 'package:mywetgrocer_app/controller/database.dart';
import 'package:mywetgrocer_app/model/cart.dart';
//import 'package:mywetgrocer_app/model/cart.dart';
import 'package:mywetgrocer_app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:mywetgrocer_app/model/user.dart';
import 'package:mywetgrocer_app/notifier/authNotifier.dart';
import 'package:mywetgrocer_app/notifier/cartNotifier.dart';
//import 'package:mywetgrocer_app/notifier/cartNotifier.dart';
import 'package:mywetgrocer_app/notifier/productNotifier.dart';
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
  //Cart _cart;
 //Product _setQuantity;
  String _imageUrl;
  String quantity;
  String subTotal;
  String prouctName;
  String price;
  //File _imageFile;
   //String locGPS = "";
 
  @override
  void initState() {
    super.initState();
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context, listen: false);
    _currentCart = cartNotifier.currentCart;
    //CartNotifier cartNotifier = Provider.of<CartNotifier>(context, listen: false);
    //_cart = cartNotifier.cart;
    //_setQuantity = Cart();
    //_imageUrl = _currentCart.image;
  }


/*
  Widget _buildGpsLocationFieldUpdating() {
    return Text( 'GPS Location : ' + _currentCart.gpsLocation);
  }

  Widget _buildGpsLocationField() {
    return Text(
        _currentCart.gpsLocation = locGPS
    );
  }

  void _getCurrentLocation() async {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      locGPS = "${position.latitude}, ${position.longitude}";
    });
  }
*/
/*
  _onCartUploaded(Cart cart) {
    CartNotifier cartNotifier = Provider.of<CartNotifier>(context, listen: false);
    cartNotifier.addCart(cart);
    Navigator.pop(context);
  }
  
*/
/*
  _saveCart() {
    print('saveCart Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    if(_formKey.currentState.validate()){

   
    }
    
    //print('form saved');

    //uploadCartAndImage(_currentCart, widget.isSelectCart, _imageFile, _onCartUploaded);
    //saveToCart(_cart, widget.isSelectCart, _onCartUploaded);

    //print("cartName: ${_currentCart.cartName}");
    //print("gpsLocation: ${_currentCart.gpsLocation}");
    //print("_imageFile ${_imageFile.toString()}");
    //("_imageUrl $_imageUrl");
  }
  */

  @override
  Widget build(BuildContext context) {
   // final user = Provider.of<User>(context);
    //AuthNotifier user = Provider.of<AuthNotifier>(context);
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
            //widget.isUpdating ? _buildGpsLocationFieldUpdating() : _buildGpsLocationField(),
            //widget.isUpdating ? SizedBox(height: 0) : 
            /*ButtonTheme(
                  child: RaisedButton(
                    child: Text('Add GPS Location', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _getCurrentLocation();
                    },
                  ),
                ),
              */
            SizedBox(height: 15), 
            TextFormField(
              decoration: InputDecoration(labelText: 'Quantity'),
              initialValue: _currentCart.quantity,
              style: TextStyle(fontSize: 20),
              validator: (val) {
                if (val.isEmpty) {
                  return 'Quantity is required';
                }
                return null;
              },
              onChanged: (val) => setState(() => quantity = val),
            ),  
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
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
                    if(_formKey.currentState.validate()) {
                      await  updateCart(uid: authNotifier.user.uid, 
                        productId: _currentCart.id,
                        productName: _currentCart.productName,
                        price: _currentCart.price,
                        quantity: quantity,
                        subTotal: subTotal
                      );
                      print('cart saved');
                      print("uid: ${authNotifier.user.uid}");
                      print("proId: ${_currentCart.id}");
                    }
                    Navigator.pop(context);
                  },
        child: Icon(Icons.check_rounded),
        foregroundColor: Colors.white,
        //backgroundColor: Colors.green,
      ),
    );
  }
}
