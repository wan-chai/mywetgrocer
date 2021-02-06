import 'package:mywetgrocer_app/controller/database.dart';
import 'package:mywetgrocer_app/notifier/authNotifier.dart';
import 'package:mywetgrocer_app/notifier/productNotifier.dart';
import 'package:mywetgrocer_app/screens/customers/cartlist.dart';
import 'package:mywetgrocer_app/screens/customers/productDetailCustomer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListCustomer extends StatefulWidget {
  @override
  _ProductListCustomerState createState() => _ProductListCustomerState();
}

class _ProductListCustomerState extends State<ProductListCustomer> {
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
        title: Text("MyWetGrocer App - Customer",
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
              leading: Image.network(
                productNotifier.productList[index].image != null
                    ? productNotifier.productList[index].image
                    : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                width: 120,
                fit: BoxFit.fitWidth,
              ),
              title: Text(productNotifier.productList[index].productName),
              subtitle: Text("RM${productNotifier.productList[index].price}/kg"),
              onTap: () {
                productNotifier.currentProduct = productNotifier.productList[index];
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return ProductDetailCustomer(
                    isSelectProduct: true,
                  );
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
    );
  }
}
