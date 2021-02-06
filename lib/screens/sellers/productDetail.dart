import 'package:mywetgrocer_app/controller/database.dart';
import 'package:mywetgrocer_app/model/product.dart';
import 'package:mywetgrocer_app/notifier/productNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'productForm.dart';

class ProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);

    _onProductDeleted(Product product) {
      Navigator.pop(context);
      productNotifier.deleteProduct(product);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('View Product Detail'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.network(
                  productNotifier.currentProduct.image != null
                      ? productNotifier.currentProduct.image
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 24),
                Text(
                  productNotifier.currentProduct.productName,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text("RM${
                  productNotifier.currentProduct.price}/kg",
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                /*Text(
                  'GPS Location: ${productNotifier.currentProduct.gpsLocation}',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),*/
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
                  return ProductForm(
                    isUpdating: true,
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
            onPressed: () => deleteProduct(productNotifier.currentProduct, _onProductDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
