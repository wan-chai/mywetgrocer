import 'package:mywetgrocer_app/controller/database.dart';
import 'package:mywetgrocer_app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:mywetgrocer_app/notifier/authNotifier.dart';
import 'package:mywetgrocer_app/notifier/productNotifier.dart';
import 'package:provider/provider.dart';

class ProductDetailCustomer extends StatefulWidget {
  final bool isSelectProduct;

  ProductDetailCustomer({@required this.isSelectProduct});

  @override
  _ProductDetailCustomerState createState() => _ProductDetailCustomerState();
}

class _ProductDetailCustomerState extends State<ProductDetailCustomer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Product _currentProduct;
  String _imageUrl;
  String quantity;
  String subTotal;
  String prouctName;
  String price;
 
  @override
  void initState() {
    super.initState();
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context, listen: false);
    _currentProduct = productNotifier.currentProduct;
    _imageUrl = _currentProduct.image;
  }

  _showImage() {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
        ],
      );
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
            _showImage(),
            SizedBox(height: 16),
            Text(_currentProduct.productName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 0),
            Text("RM${_currentProduct.price}/kg",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 15), 
            TextFormField(
              decoration: InputDecoration(labelText: 'Quantity'),
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
                      await  saveToCart(uid: authNotifier.user.uid, 
                        productId: _currentProduct.id,
                        productName: _currentProduct.productName,
                        price: _currentProduct.price,
                        quantity: quantity,
                        subTotal: subTotal
                      );
                      print('cart saved');
                      print("uid: ${authNotifier.user.uid}");
                      print("proId: ${_currentProduct.id}");
                    }
                    Navigator.pop(context);
                  },
        child: Icon(Icons.add_shopping_cart),
        foregroundColor: Colors.white,
        //backgroundColor: Colors.green,
      ),
    );
  }
}
