import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  FirebaseStorageHelper._();

  static final FirebaseStorageHelper firebaseStorageHelper =
      FirebaseStorageHelper._();

  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static final categoriesRef = firebaseStorage.ref().child('categories');

  static final productsRef = firebaseStorage.ref().child('products');

  static Future<String> uploadCategoryImage(File file) async {
    final categoryRef = categoriesRef.child('${file.uri}');
    try {
      await categoryRef.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }

    return await categoryRef.getDownloadURL();
  }

  static Future<String> uploadProductImage(File file) async {
    final productRef = productsRef.child('${file.uri}.png');
    try {
      await productRef.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }

    return await productRef.getDownloadURL();
  }
}
