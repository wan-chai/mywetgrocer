import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String id;
  String uid;
  String uuid;
  String productId;
  String productName;
  String price;
  String quantity = "";
  String subTotal = "";
  //String total;
  //String gpsLocation;
  //String image;
  Timestamp createdAt;
  //Timestamp updatedAt;

  Cart();

  Cart.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    uid = data['uid'];
    productName = data['productName'];
    price = data['price'];
    quantity = data['quantity'];
    subTotal = data['subTotal'];
    //total = data['total'];
    //gpsLocation = data['gpsLocation'];
    //image = data['image'];
    createdAt = data['createdAt'];
    //updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      //'id': uuid,
      //'uid': uid,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'subTotal': subTotal,
      'createdAt': Timestamp.now()
    };
  }
}
