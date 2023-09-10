import 'dart:developer';

import 'package:get/get.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';

class OrdersController extends GetxController {
  RxList<dynamic> orders = [].obs;
  var orderItem = {}.obs;

  @override
  void onReady() {
    super.onReady();
    orders.bindStream(FireBaseStoreHelper.getOrders());
    update();
  }

  Future<void> setOrderItem(String orderId) async {
    orderItem.clear();
    final order = orders.firstWhere((element) => element['orderId'] == orderId);
    final productList = [];
    final productIndices = order['products'].entries;
    await Future.forEach(productIndices,
        (MapEntry<String, dynamic> element) async {
      final product =
          await FireBaseStoreHelper.getProduct(element.value['product']);
      productList
          .add({'product': product, 'quantity': element.value['quantity']});
    });
    orderItem.value = {
      ...order,
      'products': productList,
    };
  }
}
