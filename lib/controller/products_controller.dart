import 'package:get/get.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';

class ProductsController extends GetxController {
  RxList<dynamic> products = [].obs;

  @override
  void onReady() {
    super.onReady();
    products.bindStream(FireBaseStoreHelper.getProducts());
    update();
  }
}
