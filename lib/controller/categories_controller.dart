import 'package:get/get.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';

class CategoriesController extends GetxController {
  RxList<dynamic> categories = [].obs;
  RxList<dynamic> productCategories = [].obs;

  @override
  void onInit() {
    super.onInit();
    categories.bindStream(FireBaseStoreHelper.getCategoriesWithSubCategories());
    productCategories.bindStream(FireBaseStoreHelper.getProductCategories());
  }
}
