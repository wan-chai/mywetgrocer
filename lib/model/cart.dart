import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String id;
  String uid;
  String uuid;
  String productId;
  String productName;
  String price;
  String quantity;
  String subTotal;
  String total;
  Timestamp createdAt;

  Cart();

  Cart.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    uid = data['uid'];
    productId = data['productId'];
    productName = data['productName'];
    price = data['price'];
    quantity = data['quantity'];
    subTotal = data['subTotal'];
    createdAt = data['createdAt'];
    //total += subTotal;
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'subTotal': subTotal,
      'createdAt': Timestamp.now()
    };
  }
}


