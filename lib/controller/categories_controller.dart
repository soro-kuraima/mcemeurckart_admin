import 'dart:developer';

import 'package:get/get.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';

class CategoriesController extends GetxController {
  RxList<dynamic> categories = [].obs;
  RxList<dynamic> rootCategories = [].obs;
  RxList<dynamic> productCategories = [].obs;

  @override
  void onInit() {
    super.onInit();
    categories.bindStream(FireBaseStoreHelper.getCategories());
    rootCategories.bindStream(FireBaseStoreHelper.getRootCategories());
    productCategories.bindStream(FireBaseStoreHelper.getProductCategories());
  }

  dynamic getCategory(String id) {
    return categories.firstWhere((element) => element['id'] == id);
  }
}
