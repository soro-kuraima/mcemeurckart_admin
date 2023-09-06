import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  FirebaseStorageHelper._();

  static final FirebaseStorageHelper firebaseStorageHelper =
      FirebaseStorageHelper._();

  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static final categoriesRef = firebaseStorage.ref().child('categories');

  static final productsRef = firebaseStorage.ref().child('products');

  static Future<String> uploadCategoryImage(Uint8List file) async {
    final categoryRef = categoriesRef.child('${file.hashCode}');
    try {
      await categoryRef.putData(file);
    } on FirebaseException catch (e) {
      print(e);
    }

    return await categoryRef.getDownloadURL();
  }

  static Future<String> uploadProductImage(Uint8List file) async {
    final productRef = productsRef.child('${file.hashCode}');
    try {
      await productRef.putData(file);
    } on FirebaseException catch (e) {
      print(e);
    }

    return await productRef.getDownloadURL();
  }
}
