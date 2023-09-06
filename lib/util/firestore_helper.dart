import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/util/firebase_auth_helper.dart';

class FireBaseStoreHelper {
  FireBaseStoreHelper._();

  static final user =
      FirebaseAuthHelper.firebaseAuthHelper.firebaseAuth.currentUser;

  static final FireBaseStoreHelper fireBaseStoreHelper =
      FireBaseStoreHelper._();
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static final genericsRef = db.collection('generics');

  /* ====== to add and get generics ====== */

  static Future<void> addGenerics(
      String genericId, Map<String, dynamic> generics) async {
    try {
      await genericsRef.doc(genericId.toLowerCase()).set({
        'title': generics['title'].toUpperCase(),
        'categories': generics['categories'],
      });
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.red400,
          colorText: AppColors.white);
    }
  }

  static Stream<List<Map<String, dynamic>>> getGenerics() {
    return genericsRef.snapshots().map((event) {
      final data = event.docs.map((e) {
        return {
          'genericId': e.id,
          'title': e.data()['title'],
          'categories': e.data()['categories'],
        };
      }).toList();
      return List.from(data);
    });
  }

  static final categoriesRef = db.collection('categories');

  static Future<void> addRootCategories(
      String categoryId, Map<String, dynamic> category) async {
    try {
      await categoriesRef.doc(categoryId.toLowerCase()).set({
        'title': category['title'].toUpperCase(),
        'isRoot': true,
        'hasSubCategories': false,
        'hasProducts': false,
        'imageUrl': category['imageUrl'],
        'generic': category['generic'],
      });
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.red400,
          colorText: AppColors.white);
    }
  }

  /* ====== to add and get categories ====== */
  static Future<void> addCategoryWithProducts(
      String categoryId, Map<String, dynamic> category) async {
    try {
      await categoriesRef.doc(categoryId.toLowerCase()).set({
        'title': category['title'].toUpperCase(),
        'hasSubCategories': false,
        'hasProducts': true,
        'products': category['products'],
        'imageUrl': category['imageUrl'],
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> addCategoryWithSubCategories(
      String categoryId, Map<String, dynamic> category) async {
    try {
      await categoriesRef.doc(categoryId.toLowerCase()).set({
        'title': category['title'],
        'hasSubCategories': true,
        'hasProducts': false,
        'subCategories': category['subCategories'],
        'imageUrl': category['imageUrl'],
      });
    } catch (e) {
      print(e);
    }
  }

  static Stream<List<Map<String, dynamic>>> getCategories() {
    return categoriesRef.snapshots().map((event) {
      final data = event.docs.map((e) {
        return {
          'categoryId': e.id,
          'title': e.data()['title'],
          'hasSubCategories': e.data()['hasSubCategories'],
          'hasProducts': e.data()['hasProducts'],
          'subCategories': e.data()['subCategories'],
          'products': e.data()['products'],
          'imageUrl': e.data()['imageUrl'],
        };
      }).toList();
      return List.from(data);
    });
  }

  static final productsRef = db.collection('products');

  /* ====== to add and get products ====== */

  static Future<void> addProduct(Map<String, dynamic> product) async {
    try {
      await productsRef.doc(product['index']).set({
        'index': product['index'],
        'title': product['title'],
        'description': product['description'],
        'stock': product['stock'],
        'price': product['price'],
        'imageUrl': product['imageUrl'],
        'generic': product['generic'],
        'category': product['category'],
      });
    } catch (e) {
      print(e);
    }
  }

  static Stream<List<Map<String, dynamic>>> getProducts() {
    return productsRef.snapshots().map((event) {
      final data = event.docs.map((e) {
        return {
          'index': e.id,
          'title': e.data()['title'],
          'description': e.data()['description'],
          'stock': e.data()['stock'],
          'price': e.data()['price'],
          'imageUrl': e.data()['imageUrl'],
          'generic': e.data()['generic'],
          'category': e.data()['category'],
        };
      }).toList();
      return List.from(data);
    });
  }

  static Future<Map<String, dynamic>> getProduct(int index) async {
    Map<String, dynamic> res = {};
    final product = productsRef.doc(index.toString());
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await product.get();
      res = documentSnapshot.data()!;
    } catch (e) {
      print(e);
    }
    return res;
  }

  /* ================= to get orders and place orders ============== */

  static final ordersRef = db.collection('orders');

  static Stream<List<Map<String, dynamic>>> getOrders() {
    return ordersRef.snapshots().map((event) {
      final data = event.docs.map((e) {
        log("logging from getOrders${e.id}");
        return {
          'orderId': e.id,
          'user': e.data()['user'],
          'products': e.data()['products'],
          'orderValue': e.data()['orderValue'],
          'orderStatus': e.data()['orderStatus'],
          'orderDate': e.data()['orderDate'],
          'imageUrl': e.data()['imageUrl'],
        };
      }).toList();
      log(data.toString());
      return List.from(data);
    });
  }

  static Stream<List<Map<String, dynamic>>> getPendingOrders() {
    return ordersRef
        .where('orderStatus', isEqualTo: 'pending')
        .snapshots()
        .map((event) {
      final data = event.docs.map((e) {
        log("logging from getOrdersByStatus${e.id}");
        return {
          'orderId': e.id,
          'user': e.data()['user'],
          'products': e.data()['products'],
          'orderValue': e.data()['orderValue'],
          'orderStatus': e.data()['orderStatus'],
          'orderDate': e.data()['orderDate'],
          'imageUrl': e.data()['imageUrl'],
        };
      }).toList();
      log(data.toString());
      return List.from(data);
    });
  }

  static Future<void> updateOrderStatus(
      String orderId, String orderStatus) async {
    try {
      await ordersRef.doc(orderId).update({'orderStatus': orderStatus});
    } catch (e) {
      print(e);
    }
  }
}
