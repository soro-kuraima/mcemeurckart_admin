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
      await genericsRef.doc(genericId).set({
        'title': generics['title'].toUpperCase(),
        'categories': [],
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
          'id': e.id,
          'title': e.data()['title'],
          'categories': e.data()['categories'],
        };
      }).toList();
      log(data.toString());
      return data;
    });
  }

  static final categoriesRef = db.collection('categories');

  static Future<void> addRootCategory(
      String categoryId, Map<String, dynamic> category) async {
    final batch = db.batch();
    try {
      final rootCategoryRef = categoriesRef.doc(categoryId);
      batch.set(rootCategoryRef, {
        'title': category['title'].toUpperCase(),
        'isRoot': category['isRoot'],
        'hasSubCategories': true,
        'hasProducts': false,
        'imageUrl': category['imageUrl'],
        'generic': category['generic'],
        'subCategories': [],
      });

      final parentGenericRef = genericsRef.doc(category['generic']);
      batch.update(parentGenericRef, {
        'categories': FieldValue.arrayUnion([categoryId])
      });

      await batch.commit();
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.red400,
          colorText: AppColors.white);
    }
  }

  static Future<void> addRootCategoryWithProducts(
      String categoryId, Map<String, dynamic> category) async {
    final batch = db.batch();
    try {
      final rootCategoryRef = categoriesRef.doc(categoryId);
      batch.set(rootCategoryRef, {
        'title': category['title'].toUpperCase(),
        'isRoot': category['isRoot'],
        'hasSubCategories': false,
        'hasProducts': true,
        'imageUrl': category['imageUrl'],
        'generic': category['generic'],
        'products': []
      });

      final parentGenericRef = genericsRef.doc(category['generic']);
      batch.update(parentGenericRef, {
        'categories': FieldValue.arrayUnion([categoryId])
      });

      await batch.commit();
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
    final batch = db.batch();

    try {
      final categoryRef = categoriesRef.doc(categoryId);
      batch.set(categoryRef, {
        'title': category['title'].toUpperCase(),
        'isRoot': category['isRoot'],
        'hasSubCategories': false,
        'hasProducts': true,
        'products': [],
        'generic': category['generic'],
        'imageUrl': category['imageUrl'],
      });

      final parentCategoryRef = categoriesRef.doc(category['parentId']);
      batch.update(parentCategoryRef, {
        'subCategories': FieldValue.arrayUnion([categoryId])
      });

      await batch.commit();
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.red400,
          colorText: AppColors.white);
    }
  }

  static Future<void> addCategoryWithSubCategories(
      String categoryId, Map<String, dynamic> category) async {
    final batch = db.batch();
    try {
      final categoryRef = categoriesRef.doc(categoryId);
      batch.set(categoryRef, {
        'title': category['title'],
        'isRoot': category['isRoot'],
        'hasSubCategories': true,
        'hasProducts': false,
        'subCategories': [],
        'generic': category['generic'],
        'imageUrl': category['imageUrl'],
      });

      final parentCategoryRef = categoriesRef.doc(category['parentId']);
      batch.update(parentCategoryRef, {
        'subCategories': FieldValue.arrayUnion([categoryId])
      });

      await batch.commit();
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.red400,
          colorText: AppColors.white);
    }
  }

  static Stream<List<Map<String, dynamic>>> getCategoriesWithSubCategories() {
    final parentCategoriesRef =
        categoriesRef.where('hasProducts', isEqualTo: false);

    return parentCategoriesRef.snapshots().map((event) {
      final data = event.docs.map((e) {
        return {
          'id': e.id,
          'title': e.data()['title'],
          'hasSubCategories': e.data()['hasSubCategories'],
          'hasProducts': e.data()['hasProducts'],
          'subCategories': e.data()['subCategories'],
          'imageUrl': e.data()['imageUrl'],
        };
      }).toList();

      return data;
    });
  }

  static Stream<List<Map<String, dynamic>>> getProductCategories() {
    final productCategoriesRef =
        categoriesRef.where('hasProducts', isEqualTo: true);

    return productCategoriesRef.snapshots().map((event) {
      final data = event.docs.map((e) {
        return {
          'id': e.id,
          'title': e.data()['title'],
          'hasSubCategories': e.data()['hasSubCategories'],
          'hasProducts': e.data()['hasProducts'],
          'products': e.data()['products'],
          'imageUrl': e.data()['imageUrl'],
        };
      }).toList();

      return data;
    });
  }

  static final productsRef = db.collection('products');

  /* ====== to add and get products ====== */

  static Future<void> addProduct(Map<String, dynamic> product) async {
    final batch = db.batch();
    try {
      final productRef = productsRef.doc(product['index'].toString());
      batch.set(productRef, {
        'index': product['index'],
        'title': product['title'],
        'description': product['description'],
        'stock': product['stock'],
        'price': product['price'],
        'imageUrl': product['imageUrl'],
        'generic': product['generic'],
        'category': product['category'],
      });
      final parentCategoryRef = categoriesRef.doc(product['category']);
      batch.update(parentCategoryRef, {
        'products': FieldValue.arrayUnion([product['index']])
      });
      await batch.commit();
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
