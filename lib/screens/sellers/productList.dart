import 'package:mywetgrocer_app/controller/database.dart';
import 'package:mywetgrocer_app/notifier/authNotifier.dart';
import 'package:mywetgrocer_app/notifier/productNotifier.dart';
import 'package:mywetgrocer_app/screens/sellers/productDetail.dart';
import 'package:mywetgrocer_app/screens/sellers/productForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context, listen: false);
    getProducts(productNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);

    print("building ProductList");
    return Scaffold(
      appBar: AppBar(
        title: Text("MyWetGrocer App",
        ),
        actions: <Widget>[
          // action button
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
              leading: Image.network(
                productNotifier.productList[index].image != null
                    ? productNotifier.productList[index].image
                    : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                width: 120,
                fit: BoxFit.fitWidth,
              ),
              title: Text(productNotifier.productList[index].productName),
              //subtitle: Text(productNotifier.productList[index].gpsLocation),
              subtitle: Text("RM${productNotifier.productList[index].price}/kg"),
              onTap: () {
                productNotifier.currentProduct = productNotifier.productList[index];
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return ProductDetail();
                }));
              },
            );
          },
          itemCount: productNotifier.productList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.black,
            );
          },
        ),
      
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productNotifier.currentProduct = null;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return ProductForm(
                isUpdating: false,
              );
            }),
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }
}
