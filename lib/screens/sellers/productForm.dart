import 'dart:io';

//import 'package:geolocator/geolocator.dart';
import 'package:mywetgrocer_app/controller/database.dart';
import 'package:mywetgrocer_app/model/product.dart';
import 'package:mywetgrocer_app/notifier/productNotifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductForm extends StatefulWidget {
  final bool isUpdating;

  ProductForm({@required this.isUpdating});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Product _currentProduct;
  String _imageUrl;
  File _imageFile;
   //String locGPS = "";
 
  @override
  void initState() {
    super.initState();
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context, listen: false);

    if (productNotifier.currentProduct != null) {
      _currentProduct = productNotifier.currentProduct;
    } else {
      _currentProduct = Product();
    }

    _imageUrl = _currentProduct.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text("Image placeholder");
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _chooseImagePicker(),
          )
        ],
      );
    } else if (_imageUrl != null) {
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
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _chooseImagePicker(),
          )
        ],
      );
    }
  }

Future<void> openCamera(BuildContext context) async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      this.setState(() {
        _imageFile = imageFile;
      });
    }
    Navigator.of(context).pop();
}

Future<void> openGallery(BuildContext context) async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      this.setState(() {
        _imageFile = imageFile;
      });
    }
    Navigator.of(context).pop();
}

//choose eather pick imaage from camera or gallary
Future<void> _chooseImagePicker() {
  return showDialog(context: context,builder:(BuildContext context){
    return AlertDialog(
      title: Text('Product from ?'),
      content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          GestureDetector(
            child: Text('Camera'),
            onTap: () {
              openCamera(context);
              },
          ),
          Padding(padding: EdgeInsets.only(top:8)),
          GestureDetector(
            child: Text('Gallery'),
            onTap: () {
              openGallery(context);
              },
          ),
        ],
      ),
      ),
    );
  }); 
}

  Widget _buildProductNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Name'),
      initialValue: _currentProduct.productName,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Product Name is required';
        }

        return null;
      },
      onSaved: (String value) {
        _currentProduct.productName = value;
      },
    );
  }

  ///////////
  Widget _buildPriceField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Price in KG'),
      //initialValue: _currentProduct.price,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Price is required';
        }

        return null;
      },
      onSaved: (String value) {
        _currentProduct.price = value;
      },
    );
  }
  //////////
/*
  Widget _buildGpsLocationFieldUpdating() {
    return Text( 'GPS Location : ' + _currentProduct.gpsLocation);
  }

  Widget _buildGpsLocationField() {
    return Text(
        _currentProduct.gpsLocation = locGPS
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
  _onProductUploaded(Product product) {
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context, listen: false);
    productNotifier.addProduct(product);
    Navigator.pop(context);
  }

  _saveProduct() {
    print('saveProduct Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    uploadProductAndImage(_currentProduct, widget.isUpdating, _imageFile, _onProductUploaded);

    print("description: ${_currentProduct.productName}");
    //print("gpsLocation: ${_currentProduct.gpsLocation}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Insert Product')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          //autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit Product" : "Create Product",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? ButtonTheme(
                    child: RaisedButton(
                      onPressed: () => _chooseImagePicker(),
                      child: Text(
                        'Add Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(height: 0),
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
            _buildProductNameField(), 
            SizedBox(height: 15), 
            _buildPriceField(), 
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveProduct();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }
}
