import 'dart:io';

import 'package:mywetgrocer_app/model/product.dart';
import 'package:mywetgrocer_app/model/cart.dart';
import 'package:mywetgrocer_app/notifier/authNotifier.dart';
import 'package:mywetgrocer_app/model/user.dart';
//import 'package:mywetgrocer_app/notifier/authNotifier.dart';
import 'package:mywetgrocer_app/notifier/productNotifier.dart';
import 'package:mywetgrocer_app/notifier/cartNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

//class DatabaseService {
  //String uid;
  //String productId;
  //String productName;
  //String price;
  //final String quantity;
  //final String subTotal;

  
  var uuid = Uuid().v4();

  //DatabaseService({ this.uid, this.productId, this.productName, this.price});

  //collection reference
  final CollectionReference cartCollection = Firestore.instance.collection("cart");

   saveToCart( {String uid, String productId, String productName, String price, String quantity, String subTotal}) async {
    return await cartCollection.document('$productName$uid').setData({
      'id': uuid,
      'uid': uid,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'subTotal': subTotal,
      'createdAt': Timestamp.now()
    });
  }

getCarts(CartNotifier cartNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('cart')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Cart> _cartList = [];

  snapshot.documents.forEach((document) {
    Cart cart = Cart.fromMap(document.data);
    _cartList.add(cart);
  });

  cartNotifier.cartList = _cartList;
}

 deleteCart( {String productName, String uid}) async {
    return await cartCollection.document('$productName$uid').delete();
  }

updateCart( {String uid, String productId, String productName, String price, String quantity, String subTotal}) async {
    return await cartCollection.document('$productName$uid').setData({
      'id': uuid,
      'uid': uid,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'subTotal': subTotal,
      'createdAt': Timestamp.now()
    });
    
  }






 
/*
  //brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
        name: doc.data['name'] ?? '',
        strength: doc.data['strength'] ?? 0,
        sugars: doc.data['sugars'] ?? ''
      );
    }).toList();
  }


  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength'],
    );
  }

  //get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
      .map(_brewListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }
  */
//}
  
login(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;
  
    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
      //return User(uid: firebaseUser.uid);

    }
  }
}

signup(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.displayName;

    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      
      await firebaseUser.updateProfile(updateInfo);
      //insert user data to collection
      CollectionReference usersCollection = Firestore.instance.collection('users');
      await usersCollection.document(firebaseUser.uid).setData({
      'name' : user.displayName,
      'contact' : user.contact,
      'role' : user.role,
    });

      await firebaseUser.reload();

      print("Sign up: $firebaseUser");

      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

getProducts(ProductNotifier productNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Products')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Product> _productList = [];

  snapshot.documents.forEach((document) {
    Product product = Product.fromMap(document.data);
    _productList.add(product);
  });

  productNotifier.productList = _productList;
}

uploadProductAndImage(Product product, bool isUpdating, File localFile, Function productUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('products/images/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadProduct(product, isUpdating, productUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadProduct(product, isUpdating, productUploaded);
  }
}

_uploadProduct(Product product, bool isUpdating, Function productUploaded, {String imageUrl}) async {
  CollectionReference productRef = Firestore.instance.collection('Products');

  if (imageUrl != null) {
    product.image = imageUrl;
  }

  if (isUpdating) {
    product.updatedAt = Timestamp.now();
    await productRef.document(product.id).updateData(product.toMap());
    productUploaded(product);
    print('updated product with id: ${product.id}');
  } 
  else {
    product.createdAt = Timestamp.now();
    DocumentReference documentRef = await productRef.add(product.toMap());
    product.id = documentRef.documentID;
    print('uploaded product successfully: ${product.toString()}');
    await documentRef.setData(product.toMap(), merge: true);
    productUploaded(product);
  }
}

deleteProduct(Product product, Function productDeleted) async {
  if (product.image != null) {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(product.image);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }

  await Firestore.instance.collection('Products').document(product.id).delete();
  productDeleted(product);
}

/*
saveCart(Cart cart, bool isSelectToCart, Function cartSaved) async {
  
  var uuid = Uuid().v4();

  CollectionReference cartCollection = Firestore.instance.collection('cart');


  if (isSelectToCart) {
    print('check isSelectToCart:');
    //cart.createdAt = Timestamp.now();
    DocumentReference documentRef = await cartCollection.add(cart.toMap());
    //cart.id = documentRef.documentID;
    print('uploaded product successfully: ${cart.toString()}');
    await documentRef.setData(cart.toMap(), merge: true);
    cartSaved(cart);
  }
  else{
    print('uploaded product unsuccessfully CHECK');
  }
}
*/