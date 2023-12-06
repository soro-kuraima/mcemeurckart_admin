import 'dart:developer';
import 'dart:ffi';

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

  static Stream<List<Map<String, dynamic>>> getUsers() {
    try {
      final usersRef = db.collection('users');
      return usersRef.snapshots().map((event) {
        return event.docs.map((e) {
          return {
            'id': e.id,
            ...e.data(),
          };
        }).toList();
      });
    } catch (e) {}
    return const Stream.empty();
  }

  static Future<Map<String, dynamic>> getUser(String email) async {
    Map<String, dynamic> res = {};
    final user = db.collection('users').where('email', isEqualTo: email);
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await user.get();
      res = querySnapshot.docs.first.data();
    } catch (e) {
      print(e);
    }
    return res;
  }

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

  static Future<void> updateCategoryImage(String id, String imageUrl) async {
    try {
      await categoriesRef.doc(id).update({'imageUrl': imageUrl});
    } catch (e) {
      print(e);
    }
  }

  static Stream<List<Map<String, dynamic>>> getCategories() {
    try {
      return categoriesRef.snapshots().map((event) {
        return event.docs.map((e) {
          return {
            'id': e.id,
            ...e.data(),
          };
        }).toList();
      });
    } catch (e) {
      print(e);
    }
    return const Stream.empty();
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

  static Stream<List<Map<String, dynamic>>> getRootCategories() {
    final rootCategoriesRef = categoriesRef.where('isRoot', isEqualTo: true);
    try {
      return rootCategoriesRef.snapshots().map((event) {
        return event.docs.map((e) {
          return {
            'id': e.id,
            ...e.data(),
          };
        }).toList();
      });
    } catch (e) {
      print(e);
    }
    return const Stream.empty();
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
        'monthlyLimit': product['monthlyLimit'],
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
          'id': e.id,
          'index': e.data()['index'],
          'title': e.data()['title'],
          'description': e.data()['description'],
          'stock': e.data()['stock'],
          'price': e.data()['price'],
          'monthlyLimit': e.data()['monthlyLimit'],
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

  static Future<void> updateProduct(Map<String, dynamic> product) async {
    try {
      await productsRef.doc(product['id']).update({
        'title': product['title'],
        'description': product['description'],
        'stock': product['stock'],
        'price': product['price'],
        'imageUrl': product['imageUrl'],
        'monthlyLimit': product['monthlyLimit'],
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> deleteProduct(String id) async {
    try {
      await productsRef.doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  /* ================= to get orders and place orders ============== */

  static final ordersRef = db.collection('orders');

  static Stream<List<Map<String, dynamic>>> getOrders() {
    return ordersRef.snapshots().map((event) {
      final data = event.docs.map((e) {
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

      return List.from(data);
    });
  }

  static Stream<List<Map<String, dynamic>>> getPendingOrders() {
    return ordersRef
        .where('orderStatus', isEqualTo: 'pending')
        .snapshots()
        .map((event) {
      final data = event.docs.map((e) {
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

      return List.from(data);
    });
  }

  static Future<void> updateOrderStatus(String orderId, dynamic products,
      {String orderStatus = 'Delivered'}) async {
    try {
      final orderRef = ordersRef.doc(orderId);
      orderRef.update({
        'orderStatus': orderStatus,
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getOrdersByDate(
      DateTime date) async {
    try {
      final endDate = DateTime(date.year, date.month, date.day + 1);
      final orders = ordersRef
          .where('orderDate', isGreaterThanOrEqualTo: date)
          .where('orderDate', isLessThanOrEqualTo: endDate);

      final querySnapshot = await orders.get();
      final data = querySnapshot.docs.map((e) {
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
      return data;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getOrdersByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final orders = ordersRef
          .where('orderDate', isGreaterThanOrEqualTo: startDate)
          .where('orderDate', isLessThanOrEqualTo: endDate);

      final querySnapshot = await orders.get();
      final data = querySnapshot.docs.map((e) {
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
      return data;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  static int getTotalNoOfUsers(List<dynamic> users) {
    return users.length;
  }

  static int getTotalNoOfOrders(List<dynamic> orders) {
    return orders.length;
  }

  static int getTotalNoOfOrdersDelivered(List<dynamic> orders) {
    return orders
        .where((element) => element['orderStatus'] == 'Delivered')
        .length;
  }

  static int getTotalRevenueGenerated(List<dynamic> orders) {
    return orders.fold(
        0,
        (previousValue, element) =>
            previousValue + int.parse(element['orderValue'].toString()));
  }
}
