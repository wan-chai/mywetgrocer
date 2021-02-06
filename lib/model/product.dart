import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String idSeller = 'abc123';
  String productName;
  String price;
  String total;
  String image;
  Timestamp createdAt;
  Timestamp updatedAt;

  Product();

  Product.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    idSeller = data['idSeller'];
    productName = data['productName'];
    price = data['price'];
    total = data['total'];
    image = data['image'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idSeller': idSeller,
      'productName': productName,
      'price': price,
      'total': total,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
